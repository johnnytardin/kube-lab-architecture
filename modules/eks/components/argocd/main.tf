resource "helm_release" "argocd" {
  count = local.component.enabled == false ? 0 : 1

  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "7.3.4"
  create_namespace = true
  namespace        = local.component.namespace
  values           = [file("${path.module}/values.yaml")]
}