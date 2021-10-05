variable "vpc_settings" {
  default = {
    prod = "10.10.0.0/16",
    stag = "10.20.0.0/16"
    dev  = "10.30.0.0/16"
  }
}

variable "region" {
  type    = string
  default = "eu-north-1"

  validation { # <--Supported only in Terraform 0.13+
    condition     = substr(var.region, 0, 3) == "eu-"
    error_message = "Must be an EUROPE AWS Region, like \"eu-\"."
  }
}
