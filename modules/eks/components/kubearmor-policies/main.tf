resource "helm_release" "kubearmor_policies" {
  count = local.component.enabled == false ? 0 : 1

  name      = "kubearmor-policies"
  chart     = "${path.module}/chart"
  namespace = local.component.namespace

  values = [
    file("${path.module}/chart/values.yaml")
  ]
}