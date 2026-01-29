module "vpc" {
  source = "../vpc"
}

data "aws_iam_roles" "eks_cluster_role_matches" {
  name_regex = "^eks-cluster-role$"
}

data "aws_iam_roles" "node_role_matches" {
  name_regex = "^eks-node-role$"
}

locals {
  eks_cluster_role_exists = length(data.aws_iam_roles.eks_cluster_role_matches.arns) > 0
  eks_node_role_exists    = length(data.aws_iam_roles.node_role_matches.arns) > 0
}

data "aws_iam_role" "eks_cluster_role_existing" {
  count = local.eks_cluster_role_exists ? 1 : 0
  name  = "eks-cluster-role"
}

data "aws_iam_role" "node_role_existing" {
  count = local.eks_node_role_exists ? 1 : 0
  name  = "eks-node-role"
}


module "iam" {
  count  = local.eks_cluster_role_exists && local.eks_node_role_exists ? 0 : 1
  source = "../iam"
}

module "eks" {
  source            = "../eks"
  cluster_name      = "eksdemo"
  role_arn          = local.eks_cluster_role_exists ? data.aws_iam_role.eks_cluster_role_existing[0].arn : module.iam[0].eks_cluster_role
  node_role_arn     = local.eks_node_role_exists ? data.aws_iam_role.node_role_existing[0].arn : module.iam[0].eks_node_role
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids= module.vpc.private_subnet_ids
  depends_on = [ module.iam,module.vpc ]
}