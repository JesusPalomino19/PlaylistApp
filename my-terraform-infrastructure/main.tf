# main.tf

provider "aws" {
  region = "us-east-1" # Cambia esto a la región que prefieras
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"

  # Habilitar la asignación de IP pública automáticamente
  map_public_ip_on_launch = true

  tags = {
    Name = "my_subnet"
  }
}

resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Cambia esto para restringir el acceso
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "my_security_group"
  }
}

resource "aws_instance" "my_instance" {
  ami                    = "ami-06b21ccaeff8cd686" # Cambia esto a la AMI que necesites
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_security_group.id]

  tags = {
    Name = "my_node_app_instance"
  }
}