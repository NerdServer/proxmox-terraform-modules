terraform {

  backend "s3" { 
    bucket = "terraform-tstates" 
    region = "garage"
    key = "Containers/tf.tfstate" 
    skip_region_validation = true 
    skip_credentials_validation = true 
    skip_requesting_account_id = true 
    use_path_style = true 
    insecure = true 
    skip_metadata_api_check = true 
    skip_s3_checksum = true 
    
    endpoints = {
      s3 = "http://10.0.50.4:30188/"
    }
    } 
    
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc07"
    }
    unifi = {
      source = "paultyng/unifi"
      version = "0.41.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure     = true
}

provider "unifi" {
  username = var.unifi_username
  password = var.unifi_password
  api_url  = var.unifi_api
  allow_insecure = true
}
