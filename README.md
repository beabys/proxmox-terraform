# Terraform Proxmox

This project provisions two VMs on Proxmox using the bpg/proxmox Terraform provider.

## Structure
- **main.tf**: Root configuration, provider, and module usage
- **variables.tf**: Input variables for provider and VMs
- **outputs.tf**: Outputs for VM IDs
- **modules/vm/**: Reusable VM module

## Provider
- Uses `bpg/proxmox` provider
- Credentials and endpoint should be set via variables or environment variables (see provider block in `main.tf`)

## VM Module
- Module at `modules/vm` provisions a single VM
- Parameters: `name`, `node_name`, and more as needed

## Usage
1. Set required variables (see `variables.tf`)
2. Run:
   ```sh
   terraform init
   terraform plan -var="vm1_name=..." -var="vm1_node_name=..." -var="vm2_name=..." -var="vm2_node_name=..."
   terraform apply
   ```
3. Review outputs for VM IDs

