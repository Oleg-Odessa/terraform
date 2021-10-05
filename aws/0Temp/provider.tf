variable "aws_access_key" {}
variable "aws_secter_key" {}
variable "aws_region" {}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secter_key
}
