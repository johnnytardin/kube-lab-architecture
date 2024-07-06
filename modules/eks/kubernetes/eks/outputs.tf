output "cluster" { value = module.cluster }
output "region" { value = var.region }
output "token" { value = data.aws_eks_cluster_auth.cluster.token }