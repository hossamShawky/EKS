# VPC
module "VPC" {
  source = "./vpc"
}
#Public-Subnet
module "Public-Subnet" {
  source             = "./public_subnets"
  vpc_id             = module.VPC.vpc_id
  igw_id             = module.VPC.igw_id
  availability_zones = var.availability_zones
  public_cidrs       = var.public_cidrs

  depends_on = [module.VPC]
}