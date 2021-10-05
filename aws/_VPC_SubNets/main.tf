provider "aws" {
  access_key = "AKIAZPKZ7BRSVZ5SAUNM"
  secret_key = "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"
  region     = "eu-north-1"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "prod_vpc"
  cidr = "10.10.0.0/16"
  tags = {
    Name = "prod"
  }
}

##############################################################
data "aws_availability_zones" "working" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpcs" "my_vpcs" {}
data "aws_vpc" "prod_vpc" {
  tags = {
    Name = "prod"
  }
}
##############################################################

resource "aws_subnet" "prod_subnet_1" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.1.0/24"
  tags = {
    Name    = "Subnet-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_subnet_2" {
  vpc_id            = data.aws_vpc.prod_vpc.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.2.0/24"
  tags = {
    Name    = "Subnet-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}
