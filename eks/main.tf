resource "aws_eks_cluster" "eks" {
  name     = var.cluster_name
  role_arn = var.role_arn

  vpc_config {
    subnet_ids = concat(
      var.public_subnet_ids,
        var.private_subnet_ids
    )
  }

}

resource "aws_eks_node_group" "nodes" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "scratch-ng"
  node_role_arn  = var.node_role_arn
  subnet_ids     = var.public_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
}
