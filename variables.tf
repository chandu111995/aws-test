# variables.tf

# AWS region
variable "region" {
  default = "us-east-1"
}

# VPC CIDR block
variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

# List of Availability Zones
variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# CIDR blocks for public subnets
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

# CIDR blocks for private subnets
variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}
