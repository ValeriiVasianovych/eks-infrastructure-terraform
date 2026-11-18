resource "kubernetes_storage_class_v1" "gp3" {
  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"

  metadata {
    name = "gp3"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  parameters = {
    fsType = "ext4"
    type   = "gp3"
  }

  depends_on = [aws_eks_addon.ebs_csi_driver]
}

# EKS ships in-tree gp2 as the default; only one StorageClass should be default.
resource "kubernetes_annotations" "gp2_not_default" {
  api_version = "storage.k8s.io/v1"
  kind        = "StorageClass"

  metadata {
    name = "gp2"
  }

  annotations = {
    "storageclass.kubernetes.io/is-default-class" = "false"
  }

  force = true

  depends_on = [kubernetes_storage_class_v1.gp3]
}
