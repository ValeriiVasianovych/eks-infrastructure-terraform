resource "kubernetes_storage_class_v1" "gp3" {
  metadata {
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
    name = "gp3"
  }

  parameters = {
    fsType = "ext4"
    type   = "gp3"
  }

  allow_volume_expansion = true
  reclaim_policy         = "Delete"
  storage_provisioner    = "kubernetes.io/aws-ebs"
  volume_binding_mode    = "WaitForFirstConsumer"
}
