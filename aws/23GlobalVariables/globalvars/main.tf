#----------------------------------------------------------
# My Terraform
#
# Global Variables in Remote State on S3
#
# Made by Oleg Drachyshyn
#----------------------------------------------------------
provider "aws" {
  region = "eu-north-1"
}

terraform {
  backend "s3" {
    bucket = "oleg-drachyshyn-terraform-state"
    key    = "globalvars/terraform.tfstate"
    region = "eu-north-1"
  }
}


#==================================================

output "company_name" {
  value = "ADV-IT for Hillel-EIS"
}

output "owner" {
  value = "Oleg Drachyshyn"
}

output "tags" {
  value = {
    Project    = "Hillel-EIS"
    CostCenter = "R&D"
    Country    = "Ukraine"
  }
}
