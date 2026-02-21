resource "random_id" "mac" {
  for_each    = var.vms
  byte_length = 3
}

locals {
  # Prefix with 'x2' valid KVM/QEMU prefix + random hex bytes
  mac = { for k, v in var.vms : k => "02:00:00:${substr(random_id.mac[k].hex, 0, 2)}:${substr(random_id.mac[k].hex, 2, 2)}:${substr(random_id.mac[k].hex, 4, 2)}" }
}

resource "unifi_user" "vm_client" {
  for_each         = var.vms
  mac              = local.mac[each.key]
  name             = each.value.name
  fixed_ip         = each.value.ip != "dhcp" && each.value.ip != "0.0.0.0" ? each.value.ip : null
  local_dns_record = each.value.name
}

resource "proxmox_vm_qemu" "vms" {
  for_each    = var.vms
  name        = each.value.name
  description = each.value.name
  target_node = each.value.target_node
  os_type     = "cloud-init"
  full_clone  = true
  memory      = each.value.memory
  cpu {
    sockets = 1
    cores   = each.value.vcpu
    type    = "host"
  }
  clone       = each.value.source_template
  agent       = 1
  scsihw      = "virtio-scsi-single"

  serial {
    id   = 0
    type = "socket"
  }

 disks {
    ide {
      ide3 {
        cloudinit {
          storage = "pve-iscsi-lun0"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size = each.value.disk_size
          storage = each.value.storage
        }
      }
    }
  }
  

 
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
    tag     = "40"
    macaddr = local.mac[each.key]
  }

  # Cloud-init section (Now set strictly to DHCP so UniFi handles it)
  ipconfig0 = "ip=dhcp"
  #ipconfig1 = "ip=${each.value.ip2}/24"
  ssh_user  = var.ssh_user
  sshkeys   = var.ssh_pub_keys
  ciuser = var.ciuser
  cipassword = var.cipassword


  
 # Adding tags from variables
  tags = each.value.tags

}

