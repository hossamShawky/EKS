#Private Subnet To Host EC2 Instance => Control EKS-Cluster & Monitoring
resource "aws_subnet" "Private-Subnet" {
  count             = length(var.private_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name" = "Private-Subnet ${count.index}"
  }
} 
#
resource "aws_eip" "EIP" {
  vpc = true
}

resource "aws_nat_gateway" "NAT" {
  allocation_id = aws_eip.EIP.id
  subnet_id     = var.public_subnet
}
#

resource "aws_route_table" "private_Rtable" {

  vpc_id = var.vpc_id
  route {
    cidr_block = var.destination
    gateway_id = aws_nat_gateway.NAT.id

  }

  tags = {
    "Name" = "Private-RT"
  }

}

resource "aws_route_table_association" "private_subnets_RT_Associate" {
  count          = length(var.private_cidrs)
  subnet_id      = aws_subnet.Private-Subnet[count.index].id
  route_table_id = aws_route_table.private_Rtable.id
}
