resource "aws_vpc" "impulse_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "impulse_igw" {
  vpc_id = aws_vpc.impulse_vpc.id
}

resource "aws_route_table" "impulse_route_table" {
  vpc_id = aws_vpc.impulse_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.impulse_igw.id
  }
}

resource "aws_route_table_association" "impulse_subnet_association" {
  count          = 3
  subnet_id      = element(aws_subnet.impulse_subnet[*].id, count.index)
  route_table_id = aws_route_table.impulse_route_table.id
}

resource "aws_subnet" "impulse_subnet" {
  count                   = 3
  vpc_id                  = aws_vpc.impulse_vpc.id
  cidr_block              = cidrsubnet(aws_vpc.impulse_vpc.cidr_block, 8, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true
}

data "aws_availability_zones" "available" {}


resource "aws_db_subnet_group" "impulse_db_subnet_group" {
  name       = "impulse-db-subnet-group"
  subnet_ids = aws_subnet.impulse_subnet[*].id
}