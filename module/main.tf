module "vpc" {
  source = "../vpc"
}

data "aws_iam_role" "eks_cluster_role_existing" {
  name = "eks-cluster-role"
}

data "aws_iam_role" "node_role_existing" {
  name = "eks-node-role"
}


module "iam" {
  count = try(data.aws_iam_role.eks_cluster_role_existing.name, "") == "" ? 1 : 0
  source = "../iam"
}

module "eks" {
  source            = "../eks"
  cluster_name      = "eksdemo"
  role_arn          = try(data.aws_iam_role.eks_cluster_role_existing.arn, module.iam.eks_cluster_role)
  node_role_arn     = try(data.aws_iam_role.node_role_existing.arn, module.iam.eks_node_role)
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids= module.vpc.private_subnet_ids
  depends_on = [ module.iam,module.vpc ]
}