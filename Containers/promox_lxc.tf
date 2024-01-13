resource "proxmox_lxc" "lxc_containers" {
  for_each        = var.lxc_containers
  target_node     = each.value.target_node
  hostname        = each.key
  ostemplate      = each.value.ostemplate
  password        = var.cipassword
  cores           = each.value.cores
  memory          = each.value.memory
  start           = each.value.start
  onboot          = each.value.onboot
  ssh_public_keys = <<-EOT
     ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCvBM/W6sik8UvbRCHvk+96cd+E4bzBB6ImiGSNDj+0/fPuv6P0QJ1AAxR/TVe5rgFBCUhruOv2grOF3XJkMou2kJdWzXqxE7kqP6WzP2270TRpf5HmrbrFi4jMQ3tum9sq2sQgL+CPDo9IrtE/DeW1q1o/BHrmfrV8FkeWgIOX4GALiN45JZx+xlkiIshKvMNv5UzH9TZ7FVTedhQK/etQWiYKm0sOz53O2fPuKS0/f1M+u1jzmw8VEqNczJyyW099SzwUOcEinz05WeazcWmfDvBdxdmCWt5m9sY1pr8JjBL0HR673AwnYzc279jne2SQt33xdTJlJ3q2swixit847BjwZTDJWqAm7NtnKVfkE2CLNbYM94+IPsDpA7MEnCgb7J+SxtLumAXI86zTwD2mmXqevsMNHqSag/87r4cIjsdT0omebwhshVboHYJ30L/EdZ9YlRngxan2pdEsS5Ib2l5ZevOp7elFW9OctuNT9l0oJxo1Dx72iT3E7+TASxE=
  EOT
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
  
  unprivileged = true
}
