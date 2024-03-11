resource "aws_key_pair" "cs_lab_key" {
  key_name   = "security_lab_key"
  public_key = file(var.public_key)
}

resource "aws_security_group" "cs_lab_sg" {
  name        = "security_lab_sg"
  description = "Allow SSH from anywhere"
  vpc_id      = aws_vpc.cs_lab_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cs_lab_instance" {
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.cs_lab_key.key_name
  subnet_id            = aws_subnet.cs_lab_subnet.id
  iam_instance_profile = aws_iam_instance_profile.cs_ec2_instance_profile.name
  tags = {
    Name = "Lab_Instance_for_S3"
  }
}