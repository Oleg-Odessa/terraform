#----------------------------------------------------------
# My Terraform
#
# Terraform Loops: Count and For if
#
# Made by Oleg.drachyshyn
#----------------------------------------------------------
provider "aws" {
  region = "eu-north-1"
}

resource "aws_iam_user" "user1" {
  name = "pushkin"
}

resource "aws_iam_user" "users" {
  count = length(var.aws_users)
  name  = element(var.aws_users, count.index)
}

#----------------------------------------------------------------

resource "aws_instance" "servers" {
  count         = 3
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  tags = {
    Name = "Server Number ${count.index + 1}"
  }
}
