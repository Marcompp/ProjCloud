locals {
  cluster_name = "my-eks-cluster"
}
module "vpc" {
  source = "git::https://git@github.com/reactiveops/terraform-vpc.git?ref=v5.0.1"

  aws_region = "us-east-1"
  az_count   = 3
  aws_azs    = "us-east-1a, us-east-1b, us-east-1c"

  global_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
module "eks" {
  source       = "git::https://github.com/terraform-aws-modules/terraform-aws-eks.git?ref=v18.1.0"
  cluster_name = local.cluster_name
  vpc_id       = module.vpc.aws_vpc_id
  subnet_ids      = module.vpc.aws_subnet_private_prod_ids


  eks_managed_node_groups = {
    green = {
      min_size     = 3
      max_size     = 3
      desired_size = 3

      instance_types = ["t2.small"]
    }
  }

  # manage_aws_auth_configmap = false
}