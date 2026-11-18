terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    encrypt      = true
    key          = "aws-eks-automation/private/prod/stage-02/infra.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = local.vpc_region

  default_tags {
    tags = {
      Environment = local.vpc_env
      ManagedBy   = "Terraform"
      Owner       = "Valerii Vasianovych"
      Project     = "AWS EKS Kubernetes Infra Automation"
      Stage       = "Stage 2 - Setup Resources Provisioning"
    }
  }
}

provider "helm" {
  kubernetes = {
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    host                   = local.cluster_endpoint

    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", local.cluster_name, "--region", local.vpc_region]
      command     = "aws"
    }
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  host                   = local.cluster_endpoint

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", local.cluster_name, "--region", local.vpc_region]
    command     = "aws"
  }
}

provider "time" {}

module "monitoring" {
  source = "../../../modules/stage_02/monitoring"

  account_id       = data.aws_caller_identity.current.account_id
  cluster_iam_arn  = local.cluster_iam_role_arn
  cluster_name     = local.cluster_name
  env              = local.vpc_env
  hosted_zone_name = var.hosted_zone_name
  region           = local.vpc_region

  internal_alb_security_group_id = local.internal_alb_security_group_id
  kube_prometheus_stack_version  = var.kube_prometheus_stack_version
  private_subnet_ids             = local.private_subnet_ids
  vpc_id                         = local.vpc_id
}
