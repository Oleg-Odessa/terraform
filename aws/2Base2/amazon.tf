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

resource "aws_instance" "amazon_linux" {
  ami                    = "ami-0f0b4cb72cf3eadf3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.amazon_linux.id]

  tags = {
    Name    = "MyWebServer_tf"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
}

resource "aws_security_group" "amazon_linux" {
  name        = "Amazon Linux Security Group"
  description = "My First SecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "Web Server SecurityGroup"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
}

