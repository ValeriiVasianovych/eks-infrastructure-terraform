output "ebs_csi_driver_iam_role_arn" {
  value       = aws_iam_role.ebs_csi_driver.arn
  description = "The IAM role ARN for the EBS CSI driver"
}

output "gp3_storage_class_name" {
  value       = kubernetes_storage_class_v1.gp3.metadata[0].name
  description = "Default gp3 StorageClass backed by the EBS CSI driver"
}
