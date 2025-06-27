variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# outputs.tf
output "vpc_id" {
  value = aws_vpc.main.id
}
