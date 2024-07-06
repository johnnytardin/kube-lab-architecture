variable "region" {}
variable "subnet_ids" {}
variable "vpc" {}
variable "cluster" {}
variable "environment" {
  default = "sandbox"
}
variable "product" {
  default = ""
}
variable "team" {
  default = ""
}
variable "owner" {
  default = ""
}
