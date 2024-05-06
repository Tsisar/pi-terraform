terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
    helm = {
      source  = "hashicorp/helm"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "proxmox"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
    config_context = "proxmox"
  }
}
