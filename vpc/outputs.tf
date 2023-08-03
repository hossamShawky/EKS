output "vpc_id" {
  value = aws_vpc.VPC.id
}
output "igw_id" {
  value = aws_internet_gateway.IGW.id
}