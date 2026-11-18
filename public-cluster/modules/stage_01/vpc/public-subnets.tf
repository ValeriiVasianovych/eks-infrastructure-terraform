resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnet_cidrs)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  map_public_ip_on_launch = true
  tags = {
    "kubernetes.io/role/elb" = "1"
    CIDR                     = element(var.public_subnet_cidrs, count.index)
    Name                     = "${var.prefix_name}-public-subnet-${count.index + 1}-${var.env}"
  }
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_subnets" {
  tags = {
    Name = "${var.prefix_name}-public-subnet-${var.env}"
  }
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public_routes" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
