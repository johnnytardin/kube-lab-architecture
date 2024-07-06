variable "environment" {}

variable "components" {}

variable "linkerd_identity_validity_period_hours" {
  description = "Updated certificate in advance of the expiration of the current certificate"
  type        = number
  default     = 7920
}

