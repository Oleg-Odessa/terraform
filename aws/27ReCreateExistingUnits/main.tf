# terraform init
### terraform taint aws_instance.node2 ###
# terraform plan/apply
provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "node1" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-1"
    Owner = "Oleg Drachyshyn"
  }
}

resource "aws_instance" "node2" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-2"
    Owner = "Oleg Drachyshyn"
  }
}

resource "aws_instance" "node3" {
  ami           = "ami-05655c267c89566dd"
  instance_type = "t3.micro"
  tags = {
    Name  = "Node-3"
    Owner = "Oleg Drachyshyn"
  }
  depends_on = [aws_instance.node2]
}
