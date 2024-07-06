resource "helm_release" "kyverno" {
  count = local.component.enabled == false ? 0 : 1

  name             = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  version          = "3.2.5"
  create_namespace = true
  namespace        = local.component.namespace
}