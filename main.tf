# Intersight Provider Information 

terraform {
  required_providers {
    intersight = {
      source  = "ciscodevnet/intersight"
      version = ">= 0.1.0"
    }
  }

   backend "remote" {
     hostname = "app.terraform.io"
      organization = "Cisco-cges"
    workspaces {
      name = "IST-Remote"
   }
 }


}

provider "intersight" {
  apikey        = var.api_key_id
  secretkey =     var.api_private_key
  endpoint      = var.api_endpoint
}

module "intersight-moids" {
  source            = "./intersight-moids"
  organization_name = var.organization_name
}


resource "intersight_adapter_config_policy" "sds-adapter-config-policy" {
  name        = "sds-adapter-config-policy"
  description = "Adapter Configuration Policy for SDS"
  organization {
    object_type = "organization.Organization"
    moid        = module.intersight-moids.organization_moid
  }
  settings {
    slot_id = "MLOM"
    eth_settings {
      lldp_enabled = true
    }
    fc_settings {
      fip_enabled = false
    }
  }

}

#------------- ADDING -----   
  
# resource "intersight_vnic_eth_qos_policy" "sds-ethernet-qos-policy" {
#   name           = "sds-ethernet-qos-policy"
#   description    = "Ethernet quality of service for SDS"
#   mtu            = 9000
#   rate_limit     = 0
#   cos            = 0
#   trust_host_cos = false
#   organization {
#     object_type = "organization.Organization"
#     moid        = module.intersight-moids.organization_moid
#   }
# }
