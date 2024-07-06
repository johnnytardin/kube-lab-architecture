locals {
  component = var.components[var.environment]["linkerd"]
}


locals {
  jaeger_values = templatefile(
    "${path.module}/jaeger-values.yaml.tpl",
    {
      jaeger_endpoint = try(local.component.jaeger_endpoint)
  })
}
