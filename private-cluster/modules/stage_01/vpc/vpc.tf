resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.prefix_name}-${var.env}"
  }
}

resource "aws_internet_gateway" "main" {
  tags = {
    Name = "igw-${var.env}"
  }
  vpc_id = aws_vpc.main.id
}
