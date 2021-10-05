variable "env" {
  default = "dev"
}

variable "prod_onwer" {
  default = "Denis Astahov"
}

variable "noprod_owner" {
  default = "Oleg Drachyshyn"
}

variable "ec2_size" {
  default = {
    "prod" = "t3.nano"
    "dev"  = "t3.micro"
  }
}

variable "allow_port_list" {
  default = {
    "prod" = ["22", "80", "443"]
    "dev"  = ["80", "443", "8080", "22"]
  }
}
