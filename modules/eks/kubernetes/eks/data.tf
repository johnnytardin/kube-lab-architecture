data "aws_eks_cluster" "cluster" {
  name = module.cluster.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.cluster.cluster_name
}
