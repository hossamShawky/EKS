# Create Specific VPC For 'EKS'

resource "aws_vpc" "VPC" {
  cidr_block = var.vpc-cidr_block
  tags = {
    "Name" = "EKS-VPC"
  }
}

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.VPC.id
  tags = {
    "Name" = "EKS_VPC-IGW"
  }
}
