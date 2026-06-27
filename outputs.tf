output "vm_ids_by_key" {
  description = "Map of module keys to created VM IDs (keys match var.vms indices used for for_each)"
  value       = { for k, m in module.vm : k => m.id }
}

output "vm_ids" {
  description = "List of created VM IDs (unordered)"
  value       = [for m in values(module.vm) : m.id]
}

output "container_ids_by_key" {
  description = "Map of module keys to created container IDs (keys match var.containers indices used for for_each)"
  value       = { for k, m in module.container : k => m.id }
}

output "container_ids" {
  description = "List of created container IDs (unordered)"
  value       = [for m in values(module.container) : m.id]
}
