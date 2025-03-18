terraform {
  required_version = ">= 1.3.0, < 2.0.0"
  # Will be filled by Terragrunt
  backend "s3" {}
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.1"
    }
  }
}
