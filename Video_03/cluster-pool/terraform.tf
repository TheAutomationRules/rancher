# Terraform backend configuration
terraform {
  required_version = ">= 1.0"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    rancher2 = {
      # REF: https://github.com/rancher/terraform-provider-rancher2
      source  = "rancher/rancher2"
      version = "~> 1.21.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}