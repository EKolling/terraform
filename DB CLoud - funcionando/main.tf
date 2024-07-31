provider "aws" {
  region = "us-east-1"
}

# VPC
resource "aws_vpc" "vpc_prod" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

# Subnets
resource "aws_subnet" "subnet_publica_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_publica_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "subnet_privada_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_privada_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-east-1b"
}

# EC2
resource "aws_instance" "webserver" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_publica_a.id
  ebs_block_device {
    device_name = "/dev/sdf"
    volume_size = 10
    volume_type = "gp2"
  }
  tags = {
    name = var.name
  }
}

resource "aws_instance" "webserver2" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.subnet_publica_b.id
  tags = {
    name = var.name2
  }
}

# EIP para NAT Gateway
resource "aws_eip" "nat" {
  domain     = "vpc" # Atualizado para usar 'domain' em vez de 'vpc'
  depends_on = [aws_internet_gateway.igw]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_prod.id
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.subnet_publica_a.id

  depends_on = [aws_internet_gateway.igw]
}

# Tabela de Roteamento Pública
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc_prod.id # Correção do nome do recurso

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Associação da Tabela de Roteamento Pública
resource "aws_route_table_association" "public_assoc_a" {
  subnet_id      = aws_subnet.subnet_publica_a.id
  route_table_id = aws_route_table.public_rt.id
}

# Tabela de Roteamento Privada
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc_prod.id # Correção do nome do recurso

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

# Associação da Tabela de Roteamento Privada
resource "aws_route_table_association" "private_assoc_a" {
  subnet_id      = aws_subnet.subnet_privada_a.id
  route_table_id = aws_route_table.private_rt.id
}


# S3
resource "aws_s3_bucket" "bucket" {
  bucket = "meu-primeiro-bucket"

  tags = {
    Name        = "minha primeira tag de bucket"
    Environment = "dev"
    created_by  = "Terraform"
    created_at  = "31-07-2024"
  }

}

