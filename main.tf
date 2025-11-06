provider "aws" {
  region = "us-west-2"
}

# ----------------------------
# Security Group
# ----------------------------

resource "aws_security_group" "luqman_security_group" {
  name        = "luqman_security_group_new4"
  description = "Allow SSH, HTTP, and HTTPS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow http from anywhere
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow ssh from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow https from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow all outgoing traffic
  }
}

variable "key_name" {
  type = string
  default = "luqman_key"
}

# ----------------------------
# Key Pair
# ----------------------------
resource "aws_key_pair" "luqman_key" {
  key_name   = var.key_name
  public_key = file("id_rsa.pub")
}

# ----------------------------
# EC2 Instance
# ----------------------------
resource "aws_instance" "luqman_server" {
  ami                         = "ami-0c5204531f799e0c6"
  instance_type               = "t3.micro"
  vpc_security_group_ids      = [aws_security_group.luqman_security_group.id]
  key_name                    = aws_key_pair.luqman_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "luqman_server"
  }

  # Wait for the instance to be ready, then run Ansible playbook locally
  provisioner "local-exec" {
    command = <<EOT
      sleep 30 && \
      ANSIBLE_HOST_KEY_CHECKING=False \
      ansible-playbook -i '${self.public_ip},' -u ec2-user \
      --private-key id_rsa deploy.yml
    EOT
  }

#    provisioner "local-exec" {
#     command = <<EOT
#       sleep 30 && \
#       ANSIBLE_HOST_KEY_CHECKING=False \
#       ansible-playbook -i '${self.public_ip},' -u ec2-user \
#       --private-key ~/.ssh/id_rsa deploy.yml
#     EOT
#   }
}

# ----------------------------
# Output
# ----------------------------
output "instance_public_ip" {
  description = "Public IP of Arinze's EC2 server"
  value       = aws_instance.luqman_server.public_ip
}