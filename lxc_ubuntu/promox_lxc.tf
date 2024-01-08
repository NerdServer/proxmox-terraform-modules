resource "proxmox_lxc" "lxc_containers" {
  for_each        = var.lxc_containers
  target_node     = each.value.target_node
  hostname        = each.key
  ostemplate      = each.value.ostemplate
  ssh_public_keys = var.ssh_public_keys
  password        = var.cipassword
     
  features {
    nesting = true
  }
  rootfs {
    storage = each.value.rootfs_storage
    size    = each.value.rootfs_size
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = each.value.ip
    gw     = each.value.gw
    tag    = each.value.tag
  }
  
  unprivileged = false
}
