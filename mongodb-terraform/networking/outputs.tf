output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gw.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  value = aws_route_table.public_rt.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "mongodb_sg_id" {
  value = aws_security_group.mongodb_sg.id
}
