provider "helm" {
  kubernetes {
    host = var.kubernetes.cluster.cluster_endpoint

    cluster_ca_certificate = base64decode(var.kubernetes.cluster.cluster_certificate_authority_data)
    token                  = var.kubernetes.token
  }
}
