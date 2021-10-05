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

resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
}

resource "aws_instance" "my_webserver" {
  ami                    = "ami-0f0b4cb72cf3eadf3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Oleg",
    l_name = "Drachyshyn",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Natasha"]
  })

  tags = {
    Name    = "MyWebServer_tf"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
  /*
  lifecycle {
    # prevent_destroy = true
    ignore_changes = ["ami", "user_data"]
  }*/
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "My WebServer SecurityGroup"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name  = "Web Server SecurityGroup"
    Owner = "Oleg Drachyshyn"
  }
}

