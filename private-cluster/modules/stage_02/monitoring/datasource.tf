data "aws_lb" "internal_alb" {
  depends_on = [time_sleep.wait_for_internal_alb]

  tags = {
    "account_id"               = var.account_id
    "elbv2.k8s.aws/cluster"    = var.cluster_name
    "environment"              = var.env
    "ingress.k8s.aws/resource" = "LoadBalancer"
    "ingress.k8s.aws/stack"    = "internal"
  }
}

resource "time_sleep" "wait_for_internal_alb" {
  depends_on = [kubernetes_ingress_v1.grafana, kubernetes_ingress_v1.prometheus]

  create_duration = "60s"
}
