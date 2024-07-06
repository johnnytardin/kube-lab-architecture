variable "region" {
  type    = string
  default = "sa-east-1"
}

variable "create_vpc" {
  description = "Boolean to determine if VPC should be created"
  type        = bool
  default     = true
}

variable "existing_vpc_id" {
  description = "ID of the existing VPC to use"
  type        = string
  default     = ""
}

variable "existing_subnet_ids" {
  description = "List of existing subnet IDs to use"
  type        = list(string)
  default     = []
}