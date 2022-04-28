provider "aws" {
  region = var.aws_region
}

terraform {
  required_version = ">= 0.14.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.11.0"
    }
  }
}

locals {
  tags = {
    "Project" : "William_Hill",
    "Env" : "Dev"
  }
}

module "william_hill_eks_cluster_role" {
  source             = "./modules/iam"
  role_name          = "william-hill-eks-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  policies           = var.eks_cluster_role_attach_policies
  tags               = local.tags
}

module "william_hill_eks_cluster_node_role" {
  source             = "./modules/iam"
  role_name          = "william-hill-eks-cluster-node-role"
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role_policy.json
  policies           = var.eks_node_group_role_attach_policies
  tags               = local.tags
}

module "william_hill_eks_cluster" {
  source                    = "./modules/eks"
  eks_cluster_name          = "william-hill-eks"
  eks_cluster_role_arn      = module.william_hill_eks_cluster_role.iam_role_arn
  vpc_subnet_ids            = ["subnet-0e4409879016969d3", "subnet-04facd5295379900c", "subnet-0f74f3b8b249401ec"]
  eks_cluster_node_role_arn = module.william_hill_eks_cluster_node_role.iam_role_arn
  tags                      = local.tags
  depends_on                = [module.william_hill_eks_cluster_role, module.william_hill_eks_cluster_node_role]
}

resource "null_resource" "kubeconfig_file" {
  provisioner "local-exec" {
    command = "aws eks update-kubeconfig --name ${module.william_hill_eks_cluster.eks_cluster_name} --region ${var.aws_region} --kubeconfig ${path.module}/KUBECONFIG"
  }
  depends_on = [module.william_hill_eks_cluster]
}