# EBS CSI Driver
data "aws_iam_policy_document" "ebs_csi_driver" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
    principals {
      identifiers = ["pods.eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.ebs_csi_driver.json
  name               = "${var.prefix_name}-ebs-csi-driver-${var.env}"
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

resource "aws_iam_policy" "ebs_csi_driver_encryption" {
  name = "${var.prefix_name}-ebs-csi-driver-encryption-${var.env}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKeyWithoutPlaintext",
          "kms:CreateGrant"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_encryption" {
  policy_arn = aws_iam_policy.ebs_csi_driver_encryption.arn
  role       = aws_iam_role.ebs_csi_driver.name
}

resource "aws_eks_pod_identity_association" "ebs_csi_driver" {
  cluster_name    = var.cluster_name
  namespace       = "kube-system"
  role_arn        = aws_iam_role.ebs_csi_driver.arn
  service_account = "ebs-csi-controller-sa"
}

resource "aws_eks_addon" "ebs_csi_driver" {
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_version
  cluster_name             = var.cluster_name
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn
}
