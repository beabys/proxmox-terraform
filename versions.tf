terraform {
  required_version = ">= 1.3.0"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.54.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}
