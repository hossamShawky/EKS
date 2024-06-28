#public Subnet For EC2
resource "aws_security_group" "Public-SG" {
  vpc_id      = var.vpc_id
  name_prefix = "public_security_group"
  tags        = { "Name" : "public-SG" }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#private Subnet  
resource "aws_security_group" "Private-SG" {
  vpc_id      = var.vpc_id
  name_prefix = "private_security_group"
  tags        = { "Name" : "private-SG" }

}
# EKS-SG
resource "aws_security_group" "eks-cluster-SG" {
  name_prefix = "EKS-Cluster-SG"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS-Cluster-SG"
  }
}
