// Root module: module calls only. Provider and version/backend configuration
// have been moved to `providers.tf` and `versions.tf` / `backend.tf`.

module "vm_master" {
  source    = "./modules/vm"
  name              = var.master.name
  node_name         = var.master.node_name
  ciuser            = var.master.ciuser
  cipassword        = var.master.cipassword
  ssh_keys          = var.master.ssh_keys
  ipconfig_ipv4     = var.master.ipconfig_ipv4
  ipconfig_gateway  = var.master.ipconfig_gateway
  vm = {
    id     = var.master.id
    cores  = var.master.cores
    memory = var.master.memory
    disk = {
      datastore_id = var.master.disk.datastore_id
      file_id      = var.master.disk.file_id
      size         = var.master.disk.size
      interface    = var.master.disk.interface
      iothread     = var.master.disk.iothread
      discard      = var.master.disk.discard
    }
    network_device = {
      bridge = var.master.network_device.bridge
    }
  }
  # ...other VM parameters...
}
