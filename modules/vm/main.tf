
terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

resource "proxmox_virtual_environment_vm" "this" {
  name      = var.name
  node_name = var.node_name

  # ...other required arguments for VM creation...

  initialization {
    user_account {
      username = var.ciuser
      password = var.cipassword
      keys     = var.ssh_keys
    }
    ip_config {
      ipv4 {
        address = var.ipconfig_ipv4
        gateway = var.ipconfig_gateway
      }
    }
  }

  #vm params
  vm_id     = var.vm.id
  cpu {
    cores = var.vm.cores
    type  = var.vm.cpu_type
  }
  memory {
    dedicated = var.vm.memory
  }

  disk {
    datastore_id = var.vm.disk.datastore_id
    file_id      = var.vm.disk.file_id
    interface    = var.vm.disk.interface
    iothread     = var.vm.disk.iothread
    discard      = var.vm.disk.discard
    size         = var.vm.disk.size
    replicate    = var.vm.disk.replicate
    ssd          = var.vm.disk.ssd
    backup       = var.vm.disk.backup
  }

  network_device {
    bridge = var.vm.network_device.bridge
  }

  # Example:
  # vm_id     = var.vm_id
  # cpu {
  #   cores = var.cores
  # }
  # memory {
  #   dedicated = var.memory
  # }
  # disk {
  #   datastore_id = var.datastore_id
  #   size         = var.disk_size
  #   interface    = "scsi0"
  # }
  # network_device {
  #   bridge = var.network_bridge
  # }
}
