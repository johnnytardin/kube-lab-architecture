variable "name" {
  type = string
}
variable "environment" {
  type    = string
  default = "sandbox"
}
variable "region" { default = "sa-east-1" }
variable "vpc" { type = string }
variable "subnet_ids" { type = list(string) }
variable "product" { default = "" }
variable "owner" { default = "" }
variable "team" { default = "" }
variable "logs_url" {
  description = "Used for Promtail authentication to send data to Loki. Example: http://user:pass@logs.domain"
  type        = string
  default     = ""
}

