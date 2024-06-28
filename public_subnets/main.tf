#Public Subnet To Host EC2 Instance => Control EKS-Cluster & Monitoring
resource "aws_subnet" "Public-Subnet" {
  count             = length(var.public_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.public_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name"                      = "Public-Subnet ${count.index}"
    "kubernetes.io/role/elb"    = "1"
    "kubernetes.io/cluster/eks" = "owned"

  }
}

resource "aws_route_table" "Public-Route-Table" {
  vpc_id = var.vpc_id
  route {
    cidr_block = var.destination
    gateway_id = var.igw_id
  }
  tags = {
    "Name" = "Public-Route-Table"
  }

}

resource "aws_route_table_association" "Public-Route-Table-Association" {
  count          = length(var.public_cidrs)
  route_table_id = aws_route_table.Public-Route-Table.id
  subnet_id      = aws_subnet.Public-Subnet[count.index].id
}
