variable "ssh_password" {
  type        = string
}

variable "ssh_user" {
  type        = string
}

variable "ssh_pub_key" {
  type        = string
}

variable "vms" {
  type        = map(any)
}


variable "source_template" {
  type = string
  
}

variable "ciuser" {
  type = string
  
}

variable "cipassword" {
  type = string
  
}

