data "aws_caller_identity" "current" {}

data "terraform_remote_state" "terraform-states-vv" {
  backend = "s3"
  config = {
    bucket  = "terraform-states-vv"
    encrypt = true
    key     = "aws-eks-automation/private/dev/stage-01/infra.tfstate"
    region  = "us-east-1"
  }
}

locals {
  # VPC values
  vpc_cidr_block = data.terraform_remote_state.terraform-states-vv.outputs.vpc_cidr_block
  vpc_env        = data.terraform_remote_state.terraform-states-vv.outputs.vpc_env
  vpc_id         = data.terraform_remote_state.terraform-states-vv.outputs.vpc_id
  vpc_region     = data.terraform_remote_state.terraform-states-vv.outputs.vpc_region

  # Subnet values
  private_subnet_cidr_blocks = data.terraform_remote_state.terraform-states-vv.outputs.private_subnet_cidr_blocks
  private_subnet_ids         = data.terraform_remote_state.terraform-states-vv.outputs.private_subnet_ids
  public_subnet_cidr_blocks  = data.terraform_remote_state.terraform-states-vv.outputs.public_subnet_cidr_blocks
  public_subnet_ids          = data.terraform_remote_state.terraform-states-vv.outputs.public_subnet_ids

  external_alb_security_group_id = data.terraform_remote_state.terraform-states-vv.outputs.external_alb_security_group_id
  internal_alb_security_group_id = data.terraform_remote_state.terraform-states-vv.outputs.internal_alb_security_group_id

  # EKS Cluster values
  cluster_endpoint          = data.terraform_remote_state.terraform-states-vv.outputs.cluster_endpoint
  cluster_iam_role_arn      = data.terraform_remote_state.terraform-states-vv.outputs.cluster_iam_role_arn
  cluster_iam_role_name     = data.terraform_remote_state.terraform-states-vv.outputs.cluster_iam_role_name
  cluster_name              = data.terraform_remote_state.terraform-states-vv.outputs.cluster_name
  cluster_security_group_id = data.terraform_remote_state.terraform-states-vv.outputs.cluster_security_group_id
  eks_oidc_issuer           = data.terraform_remote_state.terraform-states-vv.outputs.eks_oidc_issuer

  # Node Group values
  node_group_ami_type       = data.terraform_remote_state.terraform-states-vv.outputs.node_group_ami_type
  node_group_disk_size      = data.terraform_remote_state.terraform-states-vv.outputs.node_group_disk_size
  node_group_iam_role_arn   = data.terraform_remote_state.terraform-states-vv.outputs.node_group_iam_role_arn
  node_group_iam_role_name  = data.terraform_remote_state.terraform-states-vv.outputs.node_group_iam_role_name
  node_group_instance_types = data.terraform_remote_state.terraform-states-vv.outputs.node_group_instance_types
  node_group_name           = data.terraform_remote_state.terraform-states-vv.outputs.node_group_name
  node_group_status         = data.terraform_remote_state.terraform-states-vv.outputs.node_group_status
}

data "aws_eks_cluster" "eks" {
  name = local.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = local.cluster_name
}
