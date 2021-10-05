#----------------------------------------------------------
# My Terrraform
/* 
# Build WebServer during Bootstarp
*/
# Made by Oleg for Trening ADV-IT
#----------------------------------------------------------

provider "aws" {
  region = "eu-north-1"
}


resource "aws_security_group" "my_dynamic" {
  name        = "Dynamic Security Group"
  description = "My First Dynamic SecurityGroup"

  dynamic "ingress" {
    for_each = ["22", "80", "443", "1541", "8080", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = 23
    to_port     = 23
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name  = "Dynamic SecurityGroup"
    Owner = "Oleg Drachyshyn"
  }
}

