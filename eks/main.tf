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



resource "aws_eks_access_entry" "admin" {
  cluster_name = aws_eks_cluster.eks.name
  principal_arn = "arn:aws:iam::000087384605:role/AWSReservedSSO_AVM-AdministratorAccess-d97965"
  type = "STANDARD"
}

resource "aws_eks_access_policy_association" "admin_policy" {
  cluster_name = aws_eks_cluster.eks.name
  principal_arn = aws_eks_access_entry.admin.principal_arn
  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}