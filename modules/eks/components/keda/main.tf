resource "helm_release" "keda" {
  count = local.component.enabled == false ? 0 : 1

  name             = "keda"
  repository       = "https://kedacore.github.io/charts"
  chart            = "keda"
  version          = "2.14.2"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [file("${path.module}/values.yaml")]
}