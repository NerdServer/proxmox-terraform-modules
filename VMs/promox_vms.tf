resource "proxmox_vm_qemu" "vms" {
  for_each    = var.vms
  name        = each.value.name
  desc        = each.value.name
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
    id = 0
    model  = "virtio"
    bridge = "vmbr0"
    tag = "40"
  }

  # Cloud-init section
  ipconfig0 = "ip=${each.value.ip}/24,gw=${each.value.gw}"
  #ipconfig1 = "ip=${each.value.ip2}/24"
  ssh_user  = var.ssh_user
  sshkeys   = var.ssh_pub_keys
  ciuser = var.ciuser
  cipassword = var.cipassword


  
 # Adding tags from variables
  tags = each.value.tags

}

