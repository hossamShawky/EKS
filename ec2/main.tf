resource "aws_instance" "EC2-Control" {
  count                       = length(var.public_subnets_ids)
  ami                         = var.ami_id
  vpc_security_group_ids      = [var.securit_group_ids]
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = var.public_subnets_ids[count.index]
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> ./ansible/inventory"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo snap install kubectl --classic ",
      "curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip ",
      "sudo apt install unzip",
      "sudo unzip awscliv2.zip",
      "sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update",
      "aws sts get-caller-identity >> /tmp/check "
    ]
  }
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./mykey.pem")
    host        = self.public_ip
  }


  tags = {
    Name = "EC2-Control"
  }

}   