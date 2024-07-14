module "cluster-autoscaler" {
  source      = "./cluster-autoscaler"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components
}

module "aws-node-termination-handler" {
  source      = "./aws-node-termination-handler"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "metrics-server" {
  source      = "./metrics-server"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "ingress" {
  source      = "./ingress"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "keda" {
  source      = "./keda"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "kyverno" {
  source      = "./kyverno"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "kyverno-policies" {
  source      = "./kyverno-policies"
  environment = var.environment
  components  = var.components

  depends_on = [module.kyverno]
}

module "kubearmor" {
  source      = "./kubearmor"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "kubearmor-policies" {
  source      = "./kubearmor-policies"
  environment = var.environment
  components  = var.components

  depends_on = [module.kubearmor]
}

module "argocd" {
  source      = "./argocd"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "prometheus" {
  source      = "./prometheus"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "gatekeeper" {
  source      = "./gatekeeper"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "grafana" {
  source      = "./grafana"
  environment = var.environment
  components  = var.components

  depends_on = [module.cluster-autoscaler]
}

module "linkerd" {
  source      = "./linkerd"
  environment = var.environment
  components  = var.components

  depends_on = [
    module.aws-node-termination-handler,
    module.cluster-autoscaler,
    module.metrics-server,
    module.ingress,
    module.keda,
    module.kyverno,
    module.kyverno-policies,
    module.kubearmor,
    module.kubearmor-policies,
    module.argocd,
    module.prometheus,
    module.gatekeeper,
    module.grafana,
  ]
}
