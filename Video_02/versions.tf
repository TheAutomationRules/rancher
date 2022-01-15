terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      #version = "3.71.0"
      version = "3.70.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    k8s = {
      source  = "banzaicloud/k8s"
      #version = "0.8.2"
      version = "0.9.1"
    }
    local = {
      source  = "hashicorp/local"
      #version = "2.0.0"
      version = "2.1.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      #version = "1.12.0"
      version = "1.22.2"
    }
    rke = {
      source  = "rancher/rke"
      #version = "1.2.1"
      version = "1.3.0"
    }
  }
  required_version = ">= 0.13"
}