output "public_SG" {
  value = aws_security_group.Public-SG.id
}
output "private_SG" {
  value = aws_security_group.Private-SG.id
}

output "eks_SG_id" {
  value = aws_security_group.eks-cluster-SG.id
}