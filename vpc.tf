resource "aws_vpc" "cs_lab_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Test Lab VPC"
  }
}

resource "aws_subnet" "cs_lab_subnet" {
  vpc_id                  = aws_vpc.cs_lab_vpc.id
  cidr_block              = var.subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "cs_lab_igw" {
  vpc_id = aws_vpc.cs_lab_vpc.id
}

resource "aws_route_table" "cs_lab_route_table" {
  vpc_id = aws_vpc.cs_lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cs_lab_igw.id
  }
}

resource "aws_route_table_association" "security_lab_route_table_association" {
  subnet_id      = aws_subnet.cs_lab_subnet.id
  route_table_id = aws_route_table.cs_lab_route_table.id
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.cs_lab_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
}

