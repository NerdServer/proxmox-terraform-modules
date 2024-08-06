# Proxmox VMs
resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  name        = each.value.name
  description = "Managed by Terraform"
  tags        = ["terraform"]
  target_node = each.value.target_node
  on_boot     = true

  cpu {
    cores = each.value.cpu_cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory_mb
  }

  agent {
    enabled = true
  }

  network_device {
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "pve-iscsi-lun0"
    file_id      = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    file_format  = "raw"
    interface    = "virtio0"
    size         = each.value.disk_size
  }

  operating_system {
    type = "l26" # Linux Kernel 2.6 - 5.X.
  }

  initialization {
    datastore_id = "pve-iscsi-lun0"
    ip_config {
      ipv4 {
        address = "${each.value.ip_address}/24"
        gateway = var.default_gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }
}

# Talos Client Configuration
data "talos_client_configuration" "talosconfig" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  endpoints            = [for vm in var.vms : vm.ip_address]
}

# Talos Machine Configuration for Control Plane
data "talos_machine_configuration" "machineconfig_cp" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${lookup(
    [for k, v in var.vms : v.ip_address if contains(v.name, "cp")][0],
    "ip_address"
  )}:6443"
  machine_type     = "controlplane"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

# Apply Configuration for Control Plane
resource "talos_machine_configuration_apply" "cp_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.vm[for k, v in var.vms : k if contains(v.name, "cp")][0]]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_cp.machine_configuration
  count                       = 1
  node                        = lookup(var.vms, [for k, v in var.vms : k if contains(v.name, "cp")][0], "ip_address")
}

# Talos Machine Configuration for Workers
data "talos_machine_configuration" "machineconfig_worker" {
  cluster_name     = var.cluster_name
  cluster_endpoint = "https://${lookup(
    [for k, v in var.vms : v.ip_address if contains(v.name, "worker")][0],
    "ip_address"
  )}:6443"
  machine_type     = "worker"
  machine_secrets  = talos_machine_secrets.machine_secrets.machine_secrets
}

# Apply Configuration for Workers
resource "talos_machine_configuration_apply" "worker_config_apply" {
  depends_on                  = [proxmox_virtual_environment_vm.vm[for k, v in var.vms : k if contains(v.name, "worker")][0]]
  client_configuration        = talos_machine_secrets.machine_secrets.client_configuration
  machine_configuration_input = data.talos_machine_configuration.machineconfig_worker.machine_configuration
  count                       = 1
  node                        = lookup(var.vms, [for k, v in var.vms : k if contains(v.name, "worker")][0], "ip_address")
}

# Talos Bootstrap
resource "talos_machine_bootstrap" "bootstrap" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = lookup(var.vms, [for k, v in var.vms : k if contains(v.name, "cp")][0], "ip_address")
}

# Talos Cluster Health
data "talos_cluster_health" "health" {
  depends_on           = [talos_machine_configuration_apply.cp_config_apply, talos_machine_configuration_apply.worker_config_apply]
  client_configuration = data.talos_client_configuration.talosconfig.client_configuration
  control_plane_nodes  = [lookup(var.vms[for k, v in var.vms : k if contains(v.name, "cp")][0], "ip_address")]
  worker_nodes         = [lookup(var.vms[for k, v in var.vms : k if contains(v.name, "worker")][0], "ip_address")]
  endpoints            = data.talos_client_configuration.talosconfig.endpoints
}

# Talos Cluster Kubeconfig
data "talos_cluster_kubeconfig" "kubeconfig" {
  depends_on           = [talos_machine_bootstrap.bootstrap, data.talos_cluster_health.health]
  client_configuration = talos_machine_secrets.machine_secrets.client_configuration
  node                 = lookup(var.vms, [for k, v in var.vms : k if contains(v.name, "cp")][0], "ip_address")
}

# Outputs
output "talosconfig" {
  value     = data.talos_client_configuration.talosconfig.talos_config
  sensitive = true
}

output "kubeconfig" {
  value     = data.talos_cluster_kubeconfig.kubeconfig.kubeconfig_raw
  sensitive = true
}