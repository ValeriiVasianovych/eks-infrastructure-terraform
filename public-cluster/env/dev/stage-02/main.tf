terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    encrypt      = true
    key          = "aws-eks-automation/public/dev/stage-02/infra.tfstate"
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
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  host                   = local.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "time" {}

module "monitoring" {
  source           = "../../../modules/stage_02/monitoring"
  account_id       = data.aws_caller_identity.current.account_id
  cluster_iam_arn  = local.cluster_iam_role_arn
  cluster_name     = local.cluster_name
  env              = local.vpc_env
  hosted_zone_name = var.hosted_zone_name
  region           = local.vpc_region

  kube_prometheus_stack_version = var.kube_prometheus_stack_version
}
