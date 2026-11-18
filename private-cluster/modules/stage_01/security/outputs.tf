output "external_alb_security_group_id" {
  value       = aws_security_group.external_alb.id
  description = "Internet-facing ALB security group. Attach it to Ingress objects in group public."
}

output "internal_alb_security_group_id" {
  value       = aws_security_group.internal_alb.id
  description = "Internal ALB security group. Attach it to Ingress objects in group internal."
}
