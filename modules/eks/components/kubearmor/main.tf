resource "helm_release" "kubearmor" {
  count = local.component.enabled == false ? 0 : 1

  name             = "kubearmor"
  repository       = "https://kubearmor.github.io/charts"
  chart            = "kubearmor"
  version          = "1.3.2"
  create_namespace = true
  namespace        = local.component.namespace
}