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
#Private-Subnet
module "Private-Subnet" {
  source             = "./private_subnets"
  vpc_id             = module.VPC.vpc_id
  availability_zones = var.availability_zones
  private_cidrs      = var.private_cidrs
  public_subnet      = module.Public-Subnet.public_subnets_ids[0]
  depends_on         = [module.VPC, module.Public-Subnet]
}
#Security Groups
module "Security-Group" {
  source       = "./securit_groups"
  public_cidrs = var.public_cidrs
  vpc_id       = module.VPC.vpc_id
  depends_on   = [module.Public-Subnet, module.Private-Subnet]
}
# EKS
module "EKS" {
  source              = "./eks"
  private_subnets_ids = module.Private-Subnet.private_subnets_ids
  eks_sg              = module.Security-Group.eks_SG_id
  depends_on          = [module.Security-Group]
}

module "Datasource_AMI" {
  source          = "./datasource_ami/"
  filter_names    = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  filter_virtuals = ["hvm"]
  owners          = ["099720109477"] # Canonical

}

module "EC2-Control" {
  source             = "./ec2"
  ami_id             = module.Datasource_AMI.ami_id
  public_subnets_ids = module.Public-Subnet.public_subnets_ids[0]
  securit_group_ids  = module.Security-Group.public_SG
  instance_type      = "t2.micro"
  eks_arn            = module.EKS.eks_arn
  depends_on         = [module.Security-Group, module.EKS]
}


# Null Resource To print public subnets in service.yaml to enable intrent 
resource "null_resource" "print_public_subnets" {
  depends_on = [module.Public-Subnet]
  provisioner "local-exec" {
    command = <<EOT
      rm ./ansible/vars.yaml
      echo "public_subnets:" > ./ansible/vars.yaml
      %{for subnet in module.Public-Subnet.public_subnets_ids~}
      echo "  - ${subnet}" >> ./ansible/vars.yaml
      %{endfor~}
    EOT
  }

}

## Run Ansible After Provision All Resources
resource "null_resource" "ansible-playbook" {
  depends_on = [module.EC2-Control]
  provisioner "local-exec" {
    command = "/usr/bin/sh ${path.module}/ansible/ansible.sh "
  }
}


