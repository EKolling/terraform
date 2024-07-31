provider "aws" {
  region = "us-east-1" # regiao da AWS
}

resource "aws_security_group" "grupo_de_seguranca" {
  name        = "grupo_de_seguranca"
  description = "permitir acesso http e acesso a internet"

  ingress { #acesso de qualquer lugar
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress { #acesso de qualquer lugar
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #retorno a qualquer lugar
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "keypair" {
  key_name   = "terraform_keypair"
  public_key = file("~/.ssh/id_rsa.pub")


}

resource "aws_instance" "ubuntu" {
  ami                    = "ami-04a81a99f5ec58529" #qual seria a ISO da maquina
  instance_type          = "t3.nano"               #tipo de maquina
  vpc_security_group_ids = [aws_security_group.grupo_de_seguranca.id]
  user_data              = file("userdata.sh")
  key_name               = aws_key_pair.keypair.key_name

  tags = {
    name        = "ubuntu"
    description = "maquina virtual de teste"
  }
}

output "instance_public_ip" {
  description = "IPv4 publico da maquina recem criada"
  value       = aws_instance.ubuntu.public_ip
}