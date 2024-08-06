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

