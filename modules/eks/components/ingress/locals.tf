locals {
  component = var.components[var.environment]["ingress"]
}

locals {
  ingress-public = file(
    "${path.module}/values-public.yaml.tpl",
  )
}