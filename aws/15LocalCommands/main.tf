provider "aws" {
  region = "eu-north-1"
}

resource "null_resource" "command0" {
  provisioner "local-exec" {
    command = "TIME/T >> time.txt"
  }
}

resource "null_resource" "command1" {
  provisioner "local-exec" {
    command = "systeminfo >> log.txt"
  }
}

resource "null_resource" "command2" {
  provisioner "local-exec" {
    command = "ping google.com"
  }
}

resource "null_resource" "command3" {
  provisioner "local-exec" {
    command     = "print('Hello World!')"
    interpreter = ["python", "-c"]
  }
}

resource "null_resource" "command4" {
  provisioner "local-exec" {
    command = "echo $NAME1 $NAME2 $NAME3 $NAME4 >> names.txt"
    environment = {
      NAME1 = "Vasya"
      NAME2 = "Petya"
      NAME3 = "John"
      NAME4 = "Masha"
    }
  }
}

resource "aws_instance" "amazon_linux" {
  ami           = "ami-0f0b4cb72cf3eadf3"
  instance_type = "t3.micro"
  provisioner "local-exec" {
    command = "echo Hello from AWS Instance Creations!"
  }
}
resource "null_resource" "command6" {
  provisioner "local-exec" {
    command = "TIME/T >> time.txt"
  }
  depends_on = [
    null_resource.command0,
    null_resource.command1,
    null_resource.command2,
    null_resource.command3,
    null_resource.command4,
    aws_instance.amazon_linux
  ]
}
