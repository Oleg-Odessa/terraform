# Auto Fill variables for PROD

#File names can be  as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars


region                     = "eu-north-1"
instance_type              = "t3.micro"
enable_detailed_monitoring = true

allow_ports = ["22", "80", "443"]

common_tags = {
  Owner       = "Oleg Drachyshyn"
  Project     = "ADV-IT"
  CostCenter  = "KGB"
  Environment = "prod"
}

