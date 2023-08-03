output "ec2" {
  value = aws_instance.EC2-Control[*].id
}