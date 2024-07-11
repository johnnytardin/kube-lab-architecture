provider "helm" {
  kubernetes {
    host = module.kubernetes.cluster.cluster_endpoint

    cluster_ca_certificate = base64decode(module.kubernetes.cluster.cluster_certificate_authority_data)
    token                  = module.kubernetes.token
  }
}
