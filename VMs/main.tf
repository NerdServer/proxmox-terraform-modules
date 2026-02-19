terraform {

   backend "s3" { 
    bucket = "terraform-tstates" 
    region = "us-central" 
    key = "VMs/tf.tfstate" 
    skip_region_validation = true 
    skip_credentials_validation = true 
    skip_requesting_account_id = true 
    use_path_style = true 
    insecure = true 
    skip_metadata_api_check = true 
    skip_s3_checksum = true 

    endpoints {
      s3 = "http://10.0.0.243:3900"
    }
    
    } 

    
  required_providers {
    proxmox = {
      source  = "thegameprofi/proxmox"
      version = ">= 2.10.0"
    }
  }
  required_version = ">= 0.14"
}
  


provider "proxmox" {
  pm_api_url          = var.proxmox_api_url
  pm_api_token_id     = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
}
