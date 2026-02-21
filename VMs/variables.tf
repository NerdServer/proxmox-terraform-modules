variable "ssh_password" {
  type        = string
}

variable "ssh_user" {
  type        = string
}

variable "ssh_pub_keys" {
  type        = string
}

variable "vms" {
  type = map(object({
    target_node     = string
    vcpu            = optional(string, "4")
    memory          = optional(string, "16384")
    disk_size       = optional(string, "30")
    storage         = optional(string, "ssd1")
    name            = string
    ip              = string
    gw              = optional(string, "10.0.40.1")
    tags            = optional(string, "ubuntu")
    source_template = optional(string, "ubuntu22-04-template")
  }))
}



variable "ciuser" {
  type = string
  
}

variable "cipassword" {
  type = string
  
}

variable "proxmox_api_url" {
  type = string
}

variable "proxmox_api_token_id" {
  type = string
}

variable "proxmox_api_token_secret" {
  type = string
}

# variable "storage" {
#   type = string
# }
variable "unifi_username" {
  type = string
}

variable "unifi_password" {
  type = string
}

variable "unifi_api" {
  type = string
}
