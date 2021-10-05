# Auto Fill variables for DEV

#File names can be  as:
# terraform.tfvars
# prod.auto.tfvars
# dev.auto.tfvars


region                     = "eu-central-1"
instance_type              = "t3.micro"
enable_detailed_monitoring = false

allow_ports = ["22", "80", "8080"]

common_tags = {
  Owner       = "Oleg Drachyshyn"
  Project     = "ADV-IT"
  CostCenter  = "KGB"
  Environment = "development"
}

