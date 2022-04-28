resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = var.eks_cluster_role_arn
  vpc_config {
    subnet_ids = var.vpc_subnet_ids
  }
  tags = var.tags
}

resource "aws_eks_node_group" "eks_cluster_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_role_arn   = var.eks_cluster_node_role_arn
  node_group_name = "${var.eks_cluster_name}-ng"
  subnet_ids      = var.vpc_subnet_ids
  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 1
  }
}
