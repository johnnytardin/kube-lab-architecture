resource "helm_release" "cluster-autoscaler" {
  count = local.component.enabled == false ? 0 : 1

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.37.0"
  namespace  = local.component.namespace
  values     = [file("${path.module}/values.yaml")]

  set {
    name  = "autoDiscovery.clusterName"
    value = var.kubernetes.cluster.cluster_name
  }

}