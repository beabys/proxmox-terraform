terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_container" "this" {
  node_name    = var.node_name
  vm_id        = var.container.id
  description  = "Managed by Terraform"

  unprivileged = var.container.unprivileged

  features {
    nesting = var.container.nesting
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipconfig_ipv4
        gateway = var.ipconfig_gateway
      }
    }

    user_account {
      password = var.cipassword
      keys     = var.ssh_keys
    }
  }

  network_interface {
    name   = var.container.network_interface.name
    bridge = var.container.network_interface.bridge
  }

  disk {
    datastore_id = var.container.disk.datastore_id
    size         = var.container.disk.size
  }

  memory {
    dedicated = var.container.memory
  }

  cpu {
    cores = var.container.cores
  }

  operating_system {
    template_file_id = var.container.template.file_id
    type             = var.container.template.type
  }

  started       = true
  start_on_boot = true
  timeout_create = 600
}
