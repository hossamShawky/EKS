output "eks-cluster-name" {
  value = module.EKS.eks_arn
}

output "public_subnets" {
  value = module.Public-Subnet.public_subnets_ids
}