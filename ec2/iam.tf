resource "aws_iam_role" "ec2_role" {
  name = "ec2_role_eks"
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal : {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_policy" "policy" {
  name = "ec2_policy_eks"

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "eks:*",
        "Resource" : var.eks_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "role_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_instance_profile" "profile" {
  name = "ec2_Instance_Profile"
  role = aws_iam_role.ec2_role.name
}