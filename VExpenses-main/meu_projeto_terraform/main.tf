# Provedor AWS
provider "aws" {
  region = "us-east-1"  # Região que deseja usar
}

# Criação da VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VExpenses-VPC"
  }
}

# Sub-rede
resource "aws_subnet" "main_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "VExpenses-Subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "VExpenses-IGW"
  }
}

# Tabela de Roteamento
resource "aws_route_table" "main_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "VExpenses-RouteTable"
  }
}

# Associação da tabela de rotas
resource "aws_route_table_association" "main_association" {
  subnet_id      = aws_subnet.main_subnet.id
  route_table_id = aws_route_table.main_route_table.id
}

# Grupo de Segurança para permitir SSH e HTTP
resource "aws_security_group" "main_sg" {
  name        = "VExpenses-SG"
  description = "Permitir SSH e HTTP"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Permitir SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Permitir HTTP"
    from_port   = 80
    to_port     = 80
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
    Name = "VExpenses-SG"
  }
}

# Gerar uma chave SSH
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Par de Chaves EC2
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "VExpenses-Key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# Instância EC2
resource "aws_instance" "debian_ec2" {
  ami                         = "ami-06b21ccaeff8cd686"  # Corrigido para a AMI Debian correta
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_subnet.id
  vpc_security_group_ids       = [aws_security_group.main_sg.id]
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  associate_public_ip_address  = true

  # Script de inicialização para instalar o Nginx
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "VExpenses-EC2"
  }
}

# Output do IP Público da Instância EC2
output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}

# Output da chave privada gerada
output "private_key" {
  description = "Chave privada gerada para acesso SSH"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}
