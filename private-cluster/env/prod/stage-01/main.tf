terraform {
  backend "s3" {
    bucket       = "terraform-states-vv"
    encrypt      = true
    key          = "aws-eks-automation/private/prod/stage-01/infra.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Environment = var.env
      ManagedBy   = "Terraform"
      Owner       = "Valerii Vasianovych"
      Project     = "AWS EKS Kubernetes Infra Automation"
      Stage       = "Stage 1 - Infra Setup and Kubernetes Cluster Provisioning"
    }
  }
}

provider "helm" {
  kubernetes = {
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
    host                   = module.eks.cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)
  host                   = module.eks.cluster_endpoint
  token                  = data.aws_eks_cluster_auth.eks.token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    command     = "aws"
  }
}

module "vpc" {
  source = "../../../modules/stage_01/vpc"

  account_id  = data.aws_caller_identity.current.account_id
  env         = var.env
  prefix_name = var.prefix_name
  region      = var.region

  private_subnet_cidrs = ["10.0.20.0/24", "10.0.21.0/24"]
  public_subnet_cidrs  = ["10.0.10.0/24", "10.0.11.0/24"]
  vpc_cidr             = "10.0.0.0/16"
}

module "client_vpn" {
  source = "../../../modules/stage_01/client-vpn"

  env         = var.env
  prefix_name = var.prefix_name

  client_cidr_block  = var.client_cidr_block
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_cidr           = module.vpc.vpc_cidr_block
  vpc_id             = module.vpc.vpc_id

  root_certificate_chain_arn = var.vpn_client_cert_arn
  server_certificate_arn     = var.vpn_server_cert_arn
}

module "security" {
  source = "../../../modules/stage_01/security"

  client_vpn_security_group_id = module.client_vpn.security_group_id
  env                          = var.env
  prefix_name                  = var.prefix_name
  vpc_cidr                     = module.vpc.vpc_cidr_block
  vpc_id                       = module.vpc.vpc_id
}

module "eks" {
  source             = "../../../modules/stage_01/eks"
  account_id         = data.aws_caller_identity.current.id
  env                = var.env
  private_subnet_ids = module.vpc.private_subnet_ids
  public_subnet_ids  = module.vpc.public_subnet_ids
  region             = var.region
  vpc_id             = module.vpc.vpc_id

  capacity_type   = local.capacity_type
  cluster_version = local.cluster_version
  desired_size    = local.desired_size
  ingress_ports   = local.ingress_ports
  instance_types  = local.instance_types
  max_size        = local.max_size
  max_unavailable = local.max_unavailable
  min_size        = local.min_size
  prefix_name     = var.prefix_name

  coredns_version        = local.coredns_version
  kube_proxy_version     = local.kube_proxy_version
  metrics_server_version = local.metrics_server_version
  pod_identity_version   = local.pod_identity_version
  vpc_cni_version        = local.vpc_cni_version

  automation_role_arn = var.automation_role_arn

  client_vpn_security_group_id   = module.client_vpn.security_group_id
  external_alb_security_group_id = module.security.external_alb_security_group_id
  internal_alb_security_group_id = module.security.internal_alb_security_group_id

  depends_on = [module.vpc]
}

module "ebs-csi-driver" {
  source          = "../../../modules/stage_01/ebs-csi-driver"
  cluster_name    = module.eks.cluster_name
  ebs_csi_version = local.ebs_csi_version
  env             = var.env
  prefix_name     = var.prefix_name

  depends_on = [module.eks]
}

module "cluster-autoscaler" {
  source                     = "../../../modules/stage_01/cluster-autoscaler"
  cluster_autoscaler_version = local.cluster_autoscaler_version
  cluster_name               = module.eks.cluster_name
  env                        = var.env
  prefix_name                = var.prefix_name

  depends_on = [module.eks]
}

module "lb-controller" {
  source                = "../../../modules/stage_01/lb-controller"
  cert_manager_version  = local.cert_manager_version
  cluster_name          = module.eks.cluster_name
  env                   = var.env
  lb_controller_version = local.lb_controller_version
  nginx_ingress_version = local.nginx_ingress_version
  prefix_name           = var.prefix_name
  vpc_id                = module.vpc.vpc_id

  depends_on = [module.eks]
}
