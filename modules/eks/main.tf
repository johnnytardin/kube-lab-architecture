module "kubernetes" {
  source      = "./kubernetes/eks"
  region      = var.region
  product     = var.product
  owner       = var.owner
  team        = var.team
  environment = var.environment
  vpc         = var.vpc
  subnet_ids  = var.subnet_ids
  cluster     = local.cluster
}

module "components" {
  source      = "./components"
  kubernetes  = module.kubernetes
  environment = var.environment
  components  = local.components

  providers = {
    helm = helm
  }

  depends_on = [module.kubernetes]
}

