variable "aws_region" {
  default = "eu-west-2"
}

variable "eks_cluster_name" {
  default = ""
}

variable "eks_cluster_role_arn" {
  default = ""
}

variable "vpc_subnet_ids" {
  default = ""
}

variable "eks_cluster_role_attach_policies" {
  default = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy", "arn:aws:iam::aws:policy/AmazonEKSServicePolicy", "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"]
}

variable "role_name" {
  default = ""
}

variable "tags" {
  default = ""
}

variable "eks_node_group_role_attach_policies" {
  default = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
}