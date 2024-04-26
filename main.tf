# creating a random password
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
# creating namespace
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.k8s_namespace
  }
}

#  creating kubernetes secrete for grafana
resource "kubernetes_secret" "grafana_password" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = var.k8s_namespace
  }
  data = {
    admin-user = "admin"
    admin-password = random_password.password.result

  }
  depends_on = [ kubernetes_namespace.monitoring ]
}


# Deploy Prometheus and Grafana via Helm charts
resource "helm_release" "prometheus_operator" {
  name             = "kube-prometheus-stack"
  chart            = "kube-prometheus-stack"
  version          = var.prometheus_helm_version
  repository       = "https://prometheus-community.github.io/helm-charts"
  namespace        = var.k8s_namespace
  cleanup_on_fail  = true
  create_namespace = true

depends_on = [kubernetes_secret.grafana_password]
}

# Logging Helm Chart
resource "helm_release" "loki" {
  name             = "loki-stack"
  chart            = "loki-stack"
  version          = var.loki_helm_version
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = var.k8s_namespace
  create_namespace = true
  cleanup_on_fail  = true

  depends_on = [helm_release.prometheus_operator]
}


# Opentelemetry operator helm chart
resource "helm_release" "opentelemetry" {
  name             = "opentelemetry-operator"
  chart            = "opentelemetry-operator"
  version          = var.opentelemetry_helm_version
  repository       = "https://open-telemetry.github.io/opentelemetry-helm-charts"
  namespace        = var.k8s_namespace
  create_namespace = true
  cleanup_on_fail  = true
  depends_on = [kubernetes_namespace.monitoring]
}

# Grafana Tempo helm chart
resource "helm_release" "grafana_tempo" {
  name             = "tempo"
  chart            = "tempo"
  version          = var.tempo_helm_version
  repository       = "https://grafana.github.io/helm-charts"
  namespace        = var.k8s_namespace
  create_namespace = true
  cleanup_on_fail  = true

  depends_on = [kubernetes_namespace.monitoring]
}

# Otel collector manifest file
resource "kubectl_manifest" "otel_collector" {
  yaml_body = templatefile("${path.module}/files/collector.yaml", {
    collector_exporter_endpoint = var.tempo_svc
    k8s_namespace               = var.k8s_namespace
  })
  depends_on = [
    helm_release.opentelemetry,
    helm_release.grafana_tempo
  ]
}

# Instrumentation manifest file
resource "kubectl_manifest" "instrumentation" {
  yaml_body = templatefile("${path.module}/files/instrumentation.yaml", {
    service_name = var.general_name
    k8s_namespace = var.k8s_namespace
  })
  depends_on = [
    helm_release.opentelemetry,
    helm_release.grafana_tempo
  ]
}

# kubernetes service deployment
resource "kubernetes_service" "petclinic_svc" {
    metadata {
      name = var.general_name
      namespace = var.k8s_namespace
    }
    spec {
      type = "NodePort"
      port {
        port = 8080
        target_port = 8080
        node_port = 30004
      }
      selector = {
        app = var.general_name
      }
    }
}

# app metrics service
resource "kubernetes_service" "petclinic_metric_svc" {
    metadata {
      name = "${var.general_name}-metrics"
      namespace = var.k8s_namespace
    }
    spec {
      type = "ClusterIP"
      port {
        port = 9464
        name = "metrics"
        target_port = 9464
      }
      selector = {
        app = var.general_name
      }
    }
    depends_on = [ kubernetes_service.petclinic_svc ]
}
# service monitoring manifest file
resource "kubectl_manifest" "service_monitoring" {
  yaml_body = templatefile("${path.module}/files/servicemonitor.yaml", {
    service_name = var.general_name
    k8s_namespace = var.k8s_namespace
  })
  depends_on = [
    kubernetes_service.petclinic_svc,
    kubernetes_service.petclinic_metric_svc
  ]
}

# service monitoring manifest file
resource "kubectl_manifest" "petclinic_deployment" {
  yaml_body = templatefile("${path.module}/files/deployment.yaml", {
    service_name = var.general_name
    k8s_namespace = var.k8s_namespace
  })
  depends_on = [
    kubernetes_service.petclinic_svc
  ]
}