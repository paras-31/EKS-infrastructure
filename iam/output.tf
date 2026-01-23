output "eks_cluster_role" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role" {
  value = aws_iam_role.node_role.arn
}

output "node_instance_profile" {
  value = aws_iam_instance_profile.node_instance_profile.arn
}