resource "helm_release" "aws-node-termination-handler" {
  count = local.component.enabled == false ? 0 : 1

  name       = "aws-node-termination-handler"
  repository = "https://aws.github.io/eks-charts/"
  chart      = "aws-node-termination-handler"
  version    = "0.21.0"
  namespace  = local.component.namespace
  values     = [file("${path.module}/values.yaml")]
}