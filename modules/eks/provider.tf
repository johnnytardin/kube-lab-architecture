provider "helm" {
  kubernetes {
    host                   = module.kubernetes.cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.kubernetes.cluster.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.kubernetes.cluster.cluster_name, "--output", "json"]
      command     = "aws"
    }
  }
}