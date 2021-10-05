#----------------------------------------------------------
# My Terraform
#
# Made by Oleg for Trening ADV-IT
#----------------------------------------------------------

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "my_server_web" {
  ami                    = "ami-0f0b4cb72cf3eadf3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name    = "Server-Web"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
  depends_on = [aws_instance.my_server_db, aws_instance.my_server_app]
}

resource "aws_instance" "my_server_app" {
  ami                    = "ami-0f0b4cb72cf3eadf3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name    = "Server-Application"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }

  depends_on = [aws_instance.my_server_db]
}


resource "aws_instance" "my_server_db" {
  ami                    = "ami-0f0b4cb72cf3eadf3"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]

  tags = {
    Name    = "Server-Database"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
}



resource "aws_security_group" "my_webserver" {
  name = "My Security Group"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "My SecurityGroup"
    Owner   = "Oleg Drachyshyn"
    Project = "ADV-IT"
  }
}
