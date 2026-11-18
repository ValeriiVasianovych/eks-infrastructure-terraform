resource "helm_release" "kube-prometheus-stack" {
  depends_on = [kubernetes_namespace_v1.monitoring]

  name = "kube-prometheus-stack"

  chart            = "kube-prometheus-stack"
  create_namespace = false
  namespace        = kubernetes_namespace_v1.monitoring.metadata[0].name
  repository       = "https://prometheus-community.github.io/helm-charts"
  version          = var.kube_prometheus_stack_version

  values = [file("${path.module}/conf/values.yaml")]
}
