resource "helm_release" "metrics-server" {
  count = local.component.enabled == false ? 0 : 1

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.12.1"
  namespace  = local.component.namespace
  values     = [file("${path.module}/values.yaml")]
}