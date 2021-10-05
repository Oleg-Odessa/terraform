provider "aws" {
  region = "eu-north-1"
}
/*
resource "aws_instance" "my_Ubuntu" {
  count         = 2
  ami           = "ami-0afad43e7d620260c"
  instance_type = "t3.micro"
  tags = {
    Name    = "Ubuntu_tf"
    Owner   = "Oleg"
    Project = "ADV-IT"
  }
}*/

resource "aws_instance" "my_Amazon" {
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  tags = {
    Name    = "Amazon_tf"
    Owner   = "Oleg"
    Project = "ADV-IT"
  }
}
