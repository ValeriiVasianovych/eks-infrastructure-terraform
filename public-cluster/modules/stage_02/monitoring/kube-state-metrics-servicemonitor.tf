# Scrape the EKS managed kube-state-metrics addon (stage-01), not the Helm subchart.
resource "kubernetes_manifest" "kube_state_metrics_servicemonitor" {
  depends_on = [kubernetes_namespace_v1.monitoring, helm_release.kube-prometheus-stack]

  manifest = {
    apiVersion = "monitoring.coreos.com/v1"
    kind       = "ServiceMonitor"
    metadata = {
      name      = "kube-state-metrics-eks-addon"
      namespace = kubernetes_namespace_v1.monitoring.metadata[0].name
      labels = {
        "app.kubernetes.io/name" = "kube-state-metrics"
        release                  = "kube-prometheus-stack"
      }
    }
    spec = {
      jobLabel = "app.kubernetes.io/name"
      namespaceSelector = {
        matchNames = ["kube-system"]
      }
      selector = {
        matchLabels = {
          "app.kubernetes.io/name" = "kube-state-metrics"
        }
      }
      endpoints = [
        {
          port     = "http"
          interval = "30s"
        }
      ]
    }
  }
}
