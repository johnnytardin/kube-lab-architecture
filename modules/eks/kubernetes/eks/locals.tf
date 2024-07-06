locals {
  cluster_version = "1.30"
}

locals {
  name = random_pet.name.id
}

locals {
  pre_userdata_content = file("${path.module}/pre_user_data.tpl")
}

locals {
  worker_groups = var.cluster[var.environment]["worker_groups"]
}

locals {
  self_managed_node_groups = {
    for workload, workload_data in local.worker_groups :
    workload => {
      name            = workload
      use_name_prefix = true

      subnet_ids             = try(workload_data.subnet_ids, null)
      public_ip              = false
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]

      launch_template_name = "${local.name}-${workload_data.lifecycle}-${workload}"

      min_size = workload_data.min_size
      max_size = workload_data.max_size

      instance_type             = try(workload_data.instance_type, null)
      ami_type                  = try(workload_data.ami_type, null)
      desired_size              = workload_data.min_size
      bootstrap_extra_args      = "--kubelet-extra-args '--node-labels=node.kubernetes.io/lifecycle=${workload_data.lifecycle},workload=${workload_data.name}${try(workload_data.ignore_balancing, false) ? ",autoscaler-balancing-ignore=true" : ""}'"
      pre_bootstrap_user_data   = local.pre_userdata_content
      capacity_rebalance        = workload_data.lifecycle == "spot" ? false : null
      suspended_processes       = ["AZRebalance"]
      health_check_grace_period = 0
      instance_refresh          = {}

      use_mixed_instances_policy = try(workload_data.use_mixed_instances_policy, false)
      mixed_instances_policy = {
        instances_distribution = {
          on_demand_base_capacity                  = try(workload_data.on_demand_base_capacity, null)
          on_demand_percentage_above_base_capacity = try(workload_data.on_demand_percentage_above_base_capacity, null)
          spot_allocation_strategy                 = try(workload_data.spot_allocation_strategy, null)
          on_demand_allocation_strategy            = try(workload_data.on_demand_allocation_strategy, null)
          spot_instance_pools                      = try(workload_data.spot_instance_pools, null)
        }
        override = try(workload_data.override_instance_types, null)
      }

      iam_role_additional_policies = workload_data.name == "management" ? { additional = aws_iam_policy.management_additional.arn } : { additional = aws_iam_policy.worker_additional.arn }

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 125
            encrypted             = false
            delete_on_termination = true
          }
        }
      }

      enable_monitoring = false

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "optional"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

      tags = {
        "Name"                                                   = "${local.name}-${workload_data.name}-${workload_data.lifecycle}"
        "k8s.io/cluster-autoscaler/node-template/label/workload" = "${workload_data.name}"
        "aws-node-termination-handler/managed"                   = true
      }
    }
  }
}
