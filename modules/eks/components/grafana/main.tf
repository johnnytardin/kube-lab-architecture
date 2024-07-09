resource "helm_release" "grafana" {
  count = local.component.enabled == false ? 0 : 1

  name             = "grafana"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  version          = "8.3.2"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [file("${path.module}/values.yaml")]
}
