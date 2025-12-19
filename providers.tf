locals {
  proxmox_ssh_private_key = var.proxmox.ssh_private_key_path != "" ? file(var.proxmox.ssh_private_key_path) : null
}

provider "proxmox" {
  endpoint  = var.proxmox.endpoint
  api_token = var.proxmox.api_token
  insecure  = var.proxmox.insecure

  ssh {
    agent       = false
    username    = var.proxmox.ssh_user
    private_key = local.proxmox_ssh_private_key
  }
}
