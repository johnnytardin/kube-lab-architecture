resource "helm_release" "gatekeeper" {
  count = local.component.enabled == false ? 0 : 1

  name             = "gatekeeper"
  repository       = "https://open-policy-agent.github.io/gatekeeper/charts"
  chart            = "gatekeeper"
  version          = "3.16.3"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [file("${path.module}/values.yaml")]
}
