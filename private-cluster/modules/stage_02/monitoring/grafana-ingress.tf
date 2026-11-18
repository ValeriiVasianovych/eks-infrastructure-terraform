resource "kubernetes_ingress_v1" "grafana" {
  depends_on = [
    helm_release.kube-prometheus-stack,
    kubernetes_namespace_v1.monitoring,
  ]

  metadata {
    name      = "kube-prometheus-stack-grafana"
    namespace = kubernetes_namespace_v1.monitoring.metadata[0].name

    annotations = {
      "alb.ingress.kubernetes.io/backend-protocol"                    = "HTTP"
      "alb.ingress.kubernetes.io/group.name"                          = "internal"
      "alb.ingress.kubernetes.io/healthcheck-path"                    = "/api/health"
      "alb.ingress.kubernetes.io/healthcheck-port"                    = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-protocol"                = "HTTP"
      "alb.ingress.kubernetes.io/listen-ports"                        = "[{\"HTTP\":80}]"
      "alb.ingress.kubernetes.io/manage-backend-security-group-rules" = "false"
      "alb.ingress.kubernetes.io/scheme"                              = "internal"
      "alb.ingress.kubernetes.io/security-groups"                     = var.internal_alb_security_group_id
      "alb.ingress.kubernetes.io/subnets"                             = join(",", var.private_subnet_ids)
      "alb.ingress.kubernetes.io/tags"                                = "account_id=${var.account_id},environment=${var.env}"
      "alb.ingress.kubernetes.io/target-type"                         = "ip"
      "kubernetes.io/ingress.class"                                   = "alb"
    }
  }

  spec {
    ingress_class_name = "alb"

    rule {
      host = local.grafana_hostname

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = "kube-prometheus-stack-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
