module "aws-node-termination-handler" {
  source      = "./aws-node-termination-handler"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components
}

module "cluster-autoscaler" {
  source      = "./cluster-autoscaler"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components
}

module "metrics-server" {
  source      = "./metrics-server"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components
}

module "linkerd" {
  source      = "./linkerd"
  environment = var.environment
  components  = var.components
}

module "ingress" {
  source      = "./ingress"
  kubernetes  = var.kubernetes
  environment = var.environment
  components  = var.components
}

module "keda" {
  source      = "./keda"
  environment = var.environment
  components  = var.components
}

module "kyverno" {
  source      = "./kyverno"
  environment = var.environment
  components  = var.components
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
}