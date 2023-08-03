output "private_subnets_ids" {
  value = aws_subnet.Private-Subnet[*].id
}

output "nat" {
  value = aws_nat_gateway.NAT.id
}