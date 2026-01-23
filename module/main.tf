module "vpc" {
  source = "../vpc"
}

module "iam" {
  source = "../iam"
}

module "eks" {
  source            = "../eks"
  cluster_name      = "eksdemo"
  role_arn          = module.iam.eks_cluster_role
  node_role_arn     = module.iam.eks_node_role
  public_subnet_ids = module.vpc.public_subnet_ids
  private_subnet_ids= module.vpc.private_subnet_ids
  depends_on = [ module.iam,module.vpc ]
}