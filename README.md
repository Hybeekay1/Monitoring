# Monitoring
# prerequisite
1. Docker [insallation guide](https://docs.docker.com/desktop/install/linux-install/)
2. Kubernetes [insallation guide](https://minikube.sigs.k8s.io/docs/start/)
3. terraform [insallation guide](https://developer.hashicorp.com/terraform/install)
4. Helm chart [insallation guide](https://helm.sh/docs/intro/install/)
5. opentelemetry [insallation guide](https://opentelemetry.io/docs/kubernetes/operator/automatic/)
6. tempo 
7. loki 
8. promethus 
9. grafana 

### file tree

    ├── README.md
    ├── files
    │   ├── collector.yaml
    │   ├── deployment.yaml
    │   ├── instrumentation.yaml
    │   └── servicemonitor.yaml
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── terraform.tfstate
    ├── terraform.tfstate.backup
    └── variables.tf

## steps
#### initialize the working directory
      terraform init
#### preview the infrastructure 
      terraform plan
#### provision the infrastructure 
      terraform apply --auto-approve

#### output
      server@Malik:~$ kubectl get all -n monitoring
      NAME                                                         READY   STATUS    RESTARTS        AGE
      pod/alertmanager-obs-metric-kube-prometheus-alertmanager-0   2/2     Running   2 (9m14s ago)   3d15h
      pod/my-grafana-6f77dd679-nlwt5                               1/1     Running   1 (9m14s ago)   7d
      pod/my-tempo-0                                               1/1     Running   1 (9m14s ago)   7d
      pod/obs-metric-grafana-56bcf5dbf4-k4t2z                      3/3     Running   3 (9m14s ago)   3d15h
      pod/obs-metric-kube-prometheus-operator-65dd5b9b88-pl87q     1/1     Running   1 (9m14s ago)   3d15h
      pod/obs-metric-kube-state-metrics-6c4bdfd778-244db           1/1     Running   2 (9m14s ago)   3d15h
      pod/obs-metric-prometheus-node-exporter-nl2p4                1/1     Running   3 (9m14s ago)   3d15h
      pod/opentelemetry-operator-7fb78c8fb-zjv76                   2/2     Running   4 (9m14s ago)   7d
      pod/otel-collector-85b567fcb9-hhspj                          1/1     Running   1 (9m14s ago)   4d18h
      pod/petclinic-86887b88f5-k87rm                               1/1     Running   1 (9m14s ago)   3d14h
      pod/prometheus-obs-metric-kube-prometheus-prometheus-0       2/2     Running   3 (9m14s ago)   3d15h
      
      NAME                                              TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)
                                                                        AGE
      service/alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP
                                                                        3d15h
      service/my-grafana                                ClusterIP   10.101.199.245   <none>        80/TCP
                                                                        7d
      service/my-tempo                                  ClusterIP   10.100.222.230   <none>        3100/TCP,6831/UDP,6832/UDP,14268/TCP,14250/TCP,9411/TCP,55680/TCP,55681/TCP,4317/TCP,4318/TCP,55678/TCP   7d
      service/obs-metric-grafana                        ClusterIP   10.106.157.204   <none>        80/TCP
                                                                        3d15h
      service/obs-metric-kube-prometheus-alertmanager   ClusterIP   10.106.93.195    <none>        9093/TCP,8080/TCP
                                                                        3d15h
      service/obs-metric-kube-prometheus-operator       ClusterIP   10.105.175.226   <none>        443/TCP
                                                                        3d15h
      service/obs-metric-kube-prometheus-prometheus     ClusterIP   10.97.232.38     <none>        9090/TCP,8080/TCP
                                                                        3d15h
      service/obs-metric-kube-state-metrics             ClusterIP   10.96.171.145    <none>        8080/TCP
                                                                        3d15h
      service/obs-metric-prometheus-node-exporter       ClusterIP   10.102.219.88    <none>        9100/TCP
                                                                        3d15h
      service/opentelemetry-operator                    ClusterIP   10.106.231.250   <none>        8443/TCP,8080/TCP
                                                                        7d
      service/opentelemetry-operator-webhook            ClusterIP   10.101.69.115    <none>        443/TCP
                                                                        7d
      service/otel-collector                            ClusterIP   10.96.204.119    <none>        4317/TCP,4318/TCP
                                                                        6d2h
      service/otel-collector-headless                   ClusterIP   None             <none>        4317/TCP,4318/TCP
                                                                        6d2h
      service/otel-collector-monitoring                 ClusterIP   10.108.168.218   <none>        8888/TCP
                                                                        6d2h
      service/petclinic                                 NodePort    10.108.120.112   <none>        8080:30004/TCP
                                                                        6d1h
      service/petclinic-metrics                         ClusterIP   10.104.184.186   <none>        9464/TCP
                                                                        3d14h
      service/prometheus-operated                       ClusterIP   None             <none>        9090/TCP
                                                                        3d15h
      
      NAME                                                 DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
      daemonset.apps/obs-metric-prometheus-node-exporter   1         1         1       1            1           kubernetes.io/os=linux   3d15h
      
      NAME                                                  READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/my-grafana                            1/1     1            1           7d
      deployment.apps/obs-metric-grafana                    1/1     1            1           3d15h
      deployment.apps/obs-metric-kube-prometheus-operator   1/1     1            1           3d15h
      deployment.apps/obs-metric-kube-state-metrics         1/1     1            1           3d15h
      deployment.apps/opentelemetry-operator                1/1     1            1           7d
      deployment.apps/otel-collector                        1/1     1            1           6d2h
      deployment.apps/petclinic                             1/1     1            1           6d1h
      
      NAME                                                             DESIRED   CURRENT   READY   AGE
      replicaset.apps/my-grafana-6f77dd679                             1         1         1       7d
      replicaset.apps/obs-metric-grafana-56bcf5dbf4                    1         1         1       3d15h
      replicaset.apps/obs-metric-kube-prometheus-operator-65dd5b9b88   1         1         1       3d15h
      replicaset.apps/obs-metric-kube-state-metrics-6c4bdfd778         1         1         1       3d15h
      replicaset.apps/opentelemetry-operator-7fb78c8fb                 1         1         1       7d
      replicaset.apps/otel-collector-7cbfd9f4bb                        0         0         0       6d2h
      replicaset.apps/otel-collector-85b567fcb9                        1         1         1       4d18h
      replicaset.apps/otel-collector-8684fc9b49                        0         0         0       5d17h
      replicaset.apps/otel-collector-87fd68cdf                         0         0         0       5d17h
      replicaset.apps/petclinic-665d69888                              0         0         0       6d1h
      replicaset.apps/petclinic-86887b88f5                             1         1         1       3d14h
      
      NAME                                                                    READY   AGE
      statefulset.apps/alertmanager-obs-metric-kube-prometheus-alertmanager   1/1     3d15h
      statefulset.apps/my-tempo                                               1/1     7d
      statefulset.apps/prometheus-obs-metric-kube-prometheus-prometheus       1/1     3d15h
      server@Malik:~$ kubectl delete namespace monitoring
      namespace "monitoring" deleted
      server@Malik:~$ kubectl get all -n monitoring
      No resources found in monitoring namespace.
      server@Malik:~$ kubectl get all -n monitoring
      NAME                                                            READY   STATUS    RESTARTS      AGE
      pod/alertmanager-kube-prometheus-stack-alertmanager-0           2/2     Running   0             81m
      pod/kube-prometheus-stack-grafana-745f48d9-tglth                3/3     Running   0             83m
      pod/kube-prometheus-stack-kube-state-metrics-7ccc7bb9c9-4blz5   1/1     Running   0             83m
      pod/kube-prometheus-stack-operator-6bd86c894b-f6w4d             1/1     Running   0             83m
      pod/kube-prometheus-stack-prometheus-node-exporter-skgrq        1/1     Running   0             83m
      pod/loki-stack-0                                                1/1     Running   0             77m
      pod/loki-stack-promtail-mjqwb                                   1/1     Running   0             77m
      pod/opentelemetry-operator-5766b4bd98-84htd                     2/2     Running   2 (53m ago)   83m
      pod/petclinic-86887b88f5-m9z5p                                  1/1     Running   0             58m
      pod/prometheus-kube-prometheus-stack-prometheus-0               2/2     Running   0             81m
      pod/tempo-0                                                     1/1     Running   0             83m
      
      NAME                                                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)
                                                                               AGE
      service/alertmanager-operated                            ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP                                                                                81m
      service/kube-prometheus-stack-alertmanager               ClusterIP   10.96.244.20     <none>        9093/TCP,8080/TCP
                                                                               83m
      service/kube-prometheus-stack-grafana                    ClusterIP   10.101.170.129   <none>        80/TCP
                                                                               83m
      service/kube-prometheus-stack-kube-state-metrics         ClusterIP   10.110.137.164   <none>        8080/TCP
                                                                               83m
      service/kube-prometheus-stack-operator                   ClusterIP   10.100.104.219   <none>        443/TCP
                                                                               83m
      service/kube-prometheus-stack-prometheus                 ClusterIP   10.111.73.251    <none>        9090/TCP,8080/TCP
                                                                               83m
      service/kube-prometheus-stack-prometheus-node-exporter   ClusterIP   10.100.211.226   <none>        9100/TCP
                                                                               83m
      service/loki-stack                                       ClusterIP   10.96.171.64     <none>        3100/TCP
                                                                               77m
      service/loki-stack-headless                              ClusterIP   None             <none>        3100/TCP
                                                                               77m
      service/loki-stack-memberlist                            ClusterIP   None             <none>        7946/TCP
                                                                               77m
      service/opentelemetry-operator                           ClusterIP   10.98.151.86     <none>        8443/TCP,8080/TCP
                                                                               83m
      service/opentelemetry-operator-webhook                   ClusterIP   10.96.147.117    <none>        443/TCP
                                                                               83m
      service/petclinic                                        NodePort    10.103.208.160   <none>        8080:30004/TCP
                                                                               58m
      service/petclinic-metrics                                ClusterIP   10.103.144.14    <none>        9464/TCP
                                                                               65s
      service/prometheus-operated                              ClusterIP   None             <none>        9090/TCP
                                                                               81m
      service/tempo                                            ClusterIP   10.100.179.252   <none>        3100/TCP,6831/UDP,6832/UDP,14268/TCP,14250/TCP,9411/TCP,55680/TCP,55681/TCP,4317/TCP,4318/TCP,55678/TCP   83m
      
      NAME                                                            DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
      daemonset.apps/kube-prometheus-stack-prometheus-node-exporter   1         1         1       1            1           kubernetes.io/os=linux   83m
      daemonset.apps/loki-stack-promtail                              1         1         1       1            1           <none>
               77m
      
      NAME                                                       READY   UP-TO-DATE   AVAILABLE   AGE
      deployment.apps/kube-prometheus-stack-grafana              1/1     1            1           83m
      deployment.apps/kube-prometheus-stack-kube-state-metrics   1/1     1            1           83m
      deployment.apps/kube-prometheus-stack-operator             1/1     1            1           83m
      deployment.apps/opentelemetry-operator                     1/1     1            1           83m
      deployment.apps/petclinic                                  1/1     1            1           58m
      
      NAME                                                                  DESIRED   CURRENT   READY   AGE
      replicaset.apps/kube-prometheus-stack-grafana-745f48d9                1         1         1       83m
      replicaset.apps/kube-prometheus-stack-kube-state-metrics-7ccc7bb9c9   1         1         1       83m
      replicaset.apps/kube-prometheus-stack-operator-6bd86c894b             1         1         1       83m
      replicaset.apps/opentelemetry-operator-5766b4bd98                     1         1         1       83m
      replicaset.apps/petclinic-86887b88f5                                  1         1         1       58m
      
      NAME                                                               READY   AGE
      statefulset.apps/alertmanager-kube-prometheus-stack-alertmanager   1/1     81m
      statefulset.apps/loki-stack                                        1/1     77m
      statefulset.apps/prometheus-kube-prometheus-stack-prometheus       1/1     81m
      statefulset.apps/tempo                                             1/1     83m

### destroy the infrastructure
      terraform destroy --auto-aprove
