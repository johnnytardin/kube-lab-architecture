provider "aws" {
  region = var.region
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.56.1"
    }
  }
  required_version = ">= 0.13"
}
