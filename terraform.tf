# main.tf

# AWS provider
provider "aws" {
  region = var.region
}

# Create a VPC
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    name = "firstvpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "firstig"
  }
}

# Public subnets
resource "aws_subnet" "public_subnet" {
  count = length(var.availability_zones)

  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidrs[count.index]

  tags = {
    name = "ps${count.index + 1}"
  }
}

# Public Route Table
resource "aws_route_table" "prt" {
  vpc_id = aws_vpc.vpc.id
  route {
    gateway_id = aws_internet_gateway.ig.id
    cidr_block = "0.0.0.0/0"
  }
}

# Associate public subnets with the route table
resource "aws_route_table_association" "public_assoc" {
  count = length(var.public_subnet_cidrs)

  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.prt.id
}

# Private subnets
resource "aws_subnet" "private_subnet" {
  count = length(var.availability_zones)

  availability_zone = var.availability_zones[count.index]
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]

  tags = {
    name = "private-ps${count.index + 1}"
  }
}

# Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    name = "private-route-table"
  }
}

# Associate private subnets with the private route table
resource "aws_route_table_association" "private_assoc" {
  count = length(var.private_subnet_cidrs)

  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
