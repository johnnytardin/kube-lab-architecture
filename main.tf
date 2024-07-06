# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  count = var.create_vpc ? 1 : 0

  name = "sandbox"
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

# EKS
module "cluster-00" {
  name        = "clusterteste"
  source      = "./modules/eks"
  environment = "sandbox"
  product     = "k8s-product"
  vpc         = var.create_vpc ? module.vpc[0].vpc_id : var.existing_vpc_id
  subnet_ids  = var.create_vpc ? module.vpc[0].private_subnets : var.existing_subnet_ids
}
