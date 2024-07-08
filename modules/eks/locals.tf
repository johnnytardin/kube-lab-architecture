locals {
  instance_types = [
    {
      instance_type     = "m6i.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "m5.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "c6i.large"
      weighted_capacity = "1"
    },
    {
      instance_type     = "c5.large"
      weighted_capacity = "1"
    }
  ]
}

locals {
  cluster = {
    sandbox = {
      worker_groups = {
        management = {
          name          = "management"
          lifecycle     = "on-demand"
          instance_type = "m6i.large"
          ami_type      = "AL2_x86_64"
          subnet_ids    = var.subnet_ids
          min_size      = 2
          max_size      = 5
        },
        general = {
          name          = "general"
          lifecycle     = "on-demand"
          subnet_ids    = var.subnet_ids
          ami_type      = "AL2_x86_64"
          instance_type = "m6i.large"
          min_size      = 0
          max_size      = 2
        },
        batch = {
          name                                     = "batch"
          lifecycle                                = "spot"
          subnet_ids                               = var.subnet_ids
          min_size                                 = 0
          max_size                                 = 2
          on_demand_base_capacity                  = 0
          on_demand_percentage_above_base_capacity = 0
          use_mixed_instances_policy               = true
          spot_allocation_strategy                 = "price-capacity-optimized"
          spot_instance_pools                      = 0
          override_instance_types                  = local.instance_types
          ami_type                                 = "AL2_x86_64"
          on_demand_allocation_strategy            = "lowest-price"
        },
      }
    }
  }
}

locals {
  components = {
    sandbox = {
      argocd = {
        enabled   = true
        namespace = "argocd"
      }
      aws-node-termination-handler = {
        enabled   = true
        namespace = "kube-system"
      }
      cluster-autoscaler = {
        enabled   = true
        namespace = "kube-system"
      }
      metrics-server = {
        enabled   = true
        namespace = "kube-system"
      }
      ingress = {
        enabled   = true
        namespace = "traefik"
      }
      keda = {
        enabled   = true
        namespace = "keda"
      }
      linkerd = {
        enabled         = true
        namespace       = "linkerd"
        enable_viz      = false
        enable_jaeger   = false
        jaeger_endpoint = "collector.local"
      }
      kubearmor = {
        enabled   = true
        namespace = "kubearmor"
      }
      kyverno = {
        enabled   = true
        namespace = "kyverno"
      }
    }
  }
}