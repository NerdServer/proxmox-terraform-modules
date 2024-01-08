provider "random" {}

locals {
  container_names = { for i, container in var.lxc_containers : tostring(i) => element(random_pet.container_name.*.id, i) }
}

resource "random_pet" "container_name" {
  count = length(var.lxc_containers)
  length = 2
  separator = "-"
}

resource "proxmox_lxc" "lxc_containers" {
  for_each     = var.lxc_containers
  target_node  = each.value.target_node
  hostname     = local.container_names[tostring(each.key)]
  ostemplate   = each.value.ostemplate
  ssh_public_keys = var.ssh_public_keys
  
  rootfs {
    storage = each.value.rootfs_storage
    size    = each.value.rootfs_size
  }

  network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "dhcp"
        ip6 = "dhcp"
       
  }
  unprivileged = false
}