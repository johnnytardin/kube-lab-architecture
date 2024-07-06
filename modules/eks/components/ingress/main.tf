resource "helm_release" "ingress-public" {
  count = local.component.enabled == false ? 0 : 1

  name             = "traefik-public"
  repository       = "https://traefik.github.io/charts"
  chart            = "traefik"
  version          = "24.0.0"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [local.ingress-public]
}
