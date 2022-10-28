terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.34.0"
    }
  }
}

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIA3LDGB673OJZH7KI5"
  secret_key = "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"
}

resource "aws_vpc" "instance-1" {
  cidr_block       = "10.10.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "instance-1"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.instance-1.id
  cidr_block = "10.10.1.0/24"

  tags = {
    Name = "subnet-1"
  }
}
resource "aws_internet_gateway" "gate" {
  vpc_id = aws_vpc.instance-1.id

  tags = {
    Name = "gate"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.instance-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gate.id
  }


  tags = {
    Name = "example"
  }
}

resource "aws_route_table_association" "eexample" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.example.id
}

resource "aws_instance" "terraform-instance" {
  #ap-south-1
  ami           = "ami-05c8ca4485f8b138a"
  instance_type = "t2.micro"

  private_ip = "10.10.1.15"
  subnet_id  = aws_subnet.subnet-1.id
  key_name   = "terra"
}

resource "aws_eip" "test" {
  instance = aws_instance.terraform-instance.id
  vpc      = true
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.instance-1.id
}
