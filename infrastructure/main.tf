provider "aws" {
  region = "eu-west-3" # Paris
}

resource "aws_key_pair" "devops_key" {
  key_name   = "devops-key"
  public_key = file("devops_key.pub")
}

resource "aws_instance" "devops_server" {
  ami           = "ami-00c39f71452c08778" # Ubuntu 22.04 LTS Paris
  instance_type = "t2.micro"

  key_name = aws_key_pair.devops_key.key_name

  security_groups = [aws_security_group.allow_http.name]

  tags = {
    Name = "DevOps-CI-CD"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP and SSH"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "server_ip" {
  value = aws_instance.devops_server.public_ip
}
