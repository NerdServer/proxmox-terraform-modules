resource "proxmox_lxc" "lxc_containers" {
  for_each        = var.lxc_containers
  target_node     = each.value.target_node
  hostname        = each.value.container_name
  ostemplate      = each.value.ostemplate
  ssh_public_keys = var.ssh_public_keys
  
  rootfs {
    storage = each.value.rootfs_storage
    size    = each.value.rootfs_size
  }

  network {
    name   = eth0
    bridge = var.network_bridge
    ip     = var.network_ip
    gateway = var.network_gateway
    subnet = var.network_subnet
  }
  
  unprivileged = false
}
