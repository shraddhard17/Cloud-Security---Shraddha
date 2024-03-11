resource "aws_iam_role" "cs_ec2_role" {
  name = "security_lab_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "cs_ec2_policy" {
  name        = "security_lab_policy"
  description = "Allow EC2 to read S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cs_ec2_policy_attachment" {
  role       = aws_iam_role.cs_ec2_role.name
  policy_arn = aws_iam_policy.cs_ec2_policy.arn
}

resource "aws_iam_instance_profile" "cs_ec2_instance_profile" {
  name = "security_lab_instance_profile"
  role = aws_iam_role.cs_ec2_role.name
}