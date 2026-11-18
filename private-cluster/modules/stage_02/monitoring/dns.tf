# Split-horizon (same apex, two Route53 zones):
#   - aws_route53_zone.private — VPC-associated (internal ALB aliases, HTTP only)
#   - existing public zone     — future app.* records and their ACM validation, not used here
#
# Naming:
#   Internal (VPN + private zone): grafana.dev.internal.<zone>, prometheus.dev.internal.<zone>
#   External (later, public zone):  app.dev.<zone> → internet-facing ALB
#
# Client VPN pushes VPC DNS (10.0.0.2) so internal names resolve from the private zone.

resource "aws_route53_zone" "private" {
  name = var.hosted_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = {
    Name = "${var.hosted_zone_name}-private-${var.env}"
  }
}

resource "aws_route53_record" "grafana" {
  depends_on = [
    kubernetes_ingress_v1.grafana,
    time_sleep.wait_for_internal_alb,
  ]

  name    = local.grafana_record_name
  type    = "A"
  zone_id = aws_route53_zone.private.zone_id

  alias {
    evaluate_target_health = true
    name                   = data.aws_lb.internal_alb.dns_name
    zone_id                = data.aws_lb.internal_alb.zone_id
  }
}

resource "aws_route53_record" "prometheus" {
  depends_on = [
    kubernetes_ingress_v1.prometheus,
    time_sleep.wait_for_internal_alb,
  ]

  name    = local.prometheus_record_name
  type    = "A"
  zone_id = aws_route53_zone.private.zone_id

  alias {
    evaluate_target_health = true
    name                   = data.aws_lb.internal_alb.dns_name
    zone_id                = data.aws_lb.internal_alb.zone_id
  }
}
