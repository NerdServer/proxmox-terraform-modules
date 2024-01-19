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
  type        = map(any)
}



variable "ciuser" {
  type = string
  
}

variable "cipassword" {
  type = string
  
}

