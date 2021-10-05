variable "region" {
  description = "Please Enter AWS Region to deploy Server"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "Enter Instance Type"
  type        = string
  default     = "t3.micro"
}


variable "allow_ports" {
  description = "List of Ports to open for server"
  type        = list(any)
  default     = ["22", "80", "443", "8080"]
}

variable "enable_detailed_monitoring" {
  type    = bool
  default = false
}


variable "common_tags" {
  description = "Common Tags to apply to all resources"
  type        = map(any)
  default = {
    Owner       = "Oleg Drachyshyn"
    Project     = "ADV-IT"
    CostCenter  = "KGB"
    Environment = "development"
  }
}
