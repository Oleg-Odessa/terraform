provider "aws" {
  region = "eu-north-1"
}
##############################################################
data "aws_availability_zones" "working" {}

output "data_aws_availability_zones_names" {
  value = data.aws_availability_zones.working.names
  #value = data.aws_availability_zones.working.names[0]
}
##############################################################
data "aws_caller_identity" "current" {}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}
##############################################################
data "aws_region" "current" {}

output "data_aws_region_name" {
  value = data.aws_region.current.name
}

output "data_aws_region_description" {
  value = data.aws_region.current.description
}
##############################################################
data "aws_vpcs" "my_vpcs" {}

output "data_aws_vpcs_ids" {
  value = data.aws_vpcs.my_vpcs.ids
}
##############################################################
data "aws_vpc" "prod_vpc" {
  #id = var.vpc_id
  tags = {
    Name = "prod"
  }
}

output "data_aws_prod_vpc_id" {
  value = data.aws_vpc.prod_vpc.id
}

output "data_aws_prod_vpc_cidr" {
  value = data.aws_vpc.prod_vpc.cidr_block
}
##############################################################
