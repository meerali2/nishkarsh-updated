# main.tf
resource "aws_instance" "bastion_host" {
  ami                         = var.bastion_ami
  instance_type               = var.bastion_instance_type
  subnet_id                   = var.public_subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_sg_id]
  key_name                    = var.key_name
  tags = {
    Name = "Bastion-host"
    Role = "Bastion-server"
  }
}

# variables.tf
variable "public_subnet_id" {
  description = "ID of the public subnet where the bastion host will be created"
  type        = string
}

variable "bastion_sg_id" {
  description = "Security group ID for the bastion host"
  type        = string
}

variable "bastion_ami" {
  description = "AMI ID for the bastion host"
  type        = string
  default     = "ami-0ec1bf4a8f92e7bd1" # (Oregon) 
}

variable "bastion_instance_type" {
  description = "Instance type for the bastion host"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for the bastion host"
  type        = string
}

# outputs.tf
output "bastion_host_public_ip" {
  value = aws_instance.bastion_host.public_ip
}
