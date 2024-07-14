resource "random_pet" "name" {
  prefix    = var.product
  separator = "-"
}

module "cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.17.2"
  cluster_name    = local.name
  cluster_version = local.cluster_version

  subnet_ids = var.subnet_ids
  vpc_id     = var.vpc

  cluster_endpoint_public_access        = true
  cluster_endpoint_private_access       = false
  cluster_additional_security_group_ids = [aws_security_group.all_worker_mgmt.id]

  create_cloudwatch_log_group            = false
  cluster_enabled_log_types              = []
  cloudwatch_log_group_retention_in_days = 0

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  self_managed_node_group_defaults = {
    update_launch_template_default_version = true
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }
  }

  self_managed_node_groups = local.self_managed_node_groups

  enable_cluster_creator_admin_permissions = true

  tags = {
    environment = var.environment
    product     = var.product
    team        = var.team
    owner       = var.owner
  }
}
