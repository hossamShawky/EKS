#Private Subnet To Host EC2 Instance => Control EKS-Cluster & Monitoring
resource "aws_subnet" "Private-Subnet" {
  count             = length(var.private_cidrs)
  vpc_id               = var.vpc_id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name" = "Private-Subnet ${count.index}"
  }
} 