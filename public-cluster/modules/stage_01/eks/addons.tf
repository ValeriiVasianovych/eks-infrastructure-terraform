# Pod indentity
resource "aws_eks_addon" "eks_pod_identity" {
  addon_name    = "eks-pod-identity-agent"
  addon_version = var.pod_identity_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}

# CoreDNS
resource "aws_eks_addon" "coredns" {
  addon_name    = "coredns"
  addon_version = var.coredns_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}

# Kube Proxy
resource "aws_eks_addon" "kube_proxy" {
  addon_name    = "kube-proxy"
  addon_version = var.kube_proxy_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}

# VPC CNI
resource "aws_eks_addon" "vpc_cni" {
  addon_name    = "vpc-cni"
  addon_version = var.vpc_cni_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}

resource "aws_eks_addon" "kube_state_metrics" {
  addon_name    = "kube-state-metrics"
  addon_version = var.kube_state_metrics_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}

resource "aws_eks_addon" "metrics_server" {
  addon_name    = "metrics-server"
  addon_version = var.metrics_server_version
  cluster_name  = aws_eks_cluster.eks.name

  depends_on = [aws_eks_node_group.nodes]
}
