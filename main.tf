module "vm" {
  source   = "./modules/vm"
  for_each = { for idx, vm in var.vms : idx => vm }

  name             = each.value.name
  node_name        = each.value.node_name
  ciuser           = each.value.ciuser
  cipassword       = each.value.cipassword
  ssh_keys         = each.value.ssh_keys
  ipconfig_ipv4    = each.value.ipconfig_ipv4
  ipconfig_gateway = each.value.ipconfig_gateway
  vm               = each.value.vm
}

module "container" {
  source   = "./modules/container"
  for_each = { for idx, c in var.containers : idx => c }

  hostname         = each.value.hostname
  node_name        = each.value.node_name
  cipassword       = each.value.cipassword
  ssh_keys         = each.value.ssh_keys
  ipconfig_ipv4    = each.value.ipconfig_ipv4
  ipconfig_gateway = each.value.ipconfig_gateway
  container        = each.value.container
}
