data "aws_ami" "ubuntu_img" {
  most_recent = true
  filter {
    name   = "name"
    values = var.filter_names
  }
  filter {
    name   = "virtualization-type"
    values = var.filter_virtuals
  }
  owners = var.owners
}