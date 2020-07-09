terraform {
  backend "s3" {}
}

provider "aws" {
  region = "eu-west-1"
}


# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_classiclink   = var.enable_classiclink
  instance_tenancy     = "default"

  tags = {
    Name = "${var.env}-vpc"
  }
}

# IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-igw"
  }
}

# Subnets
## Public
### AZ1
resource "aws_subnet" "subnet-public-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spb1
  map_public_ip_on_launch = var.map_public_ip_on_launch_spb1
  availability_zone       = var.availability_zone_spb1
  tags = {
    Name = "${var.env}-subnet-public-1"
  }
}

### AZ2
resource "aws_subnet" "subnet-public-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spb2
  map_public_ip_on_launch = var.map_public_ip_on_launch_spb2
  availability_zone       = var.availability_zone_spb2
  tags = {
    Name = "${var.env}-subnet-public-2"
  }
}

### AZ3
resource "aws_subnet" "subnet-public-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spb3
  map_public_ip_on_launch = var.map_public_ip_on_launch_spb3
  availability_zone       = var.availability_zone_spb3
  tags = {
    Name = "${var.env}-subnet-public-3"
  }
}

## Private
### AZ1
resource "aws_subnet" "subnet-private-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spr1
  map_public_ip_on_launch = var.map_public_ip_on_launch_spr1
  availability_zone       = var.availability_zone_spr1
  tags = {
    Name = "${var.env}-subnet-private-1"
  }
}

### AZ2
resource "aws_subnet" "subnet-private-2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spr2
  map_public_ip_on_launch = var.map_public_ip_on_launch_spr2
  availability_zone       = var.availability_zone_spr2
  tags = {
    Name = "${var.env}-subnet-private-2"
  }
}

### AZ3
resource "aws_subnet" "subnet-private-3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.cidr_block_spr3
  map_public_ip_on_launch = var.map_public_ip_on_launch_spr3
  availability_zone       = var.availability_zone_spr3
  tags = {
    Name = "${var.env}-subnet-private-3"
  }
}

# Nat Instance
resource "aws_instance" "nat" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet-public-1.id
  vpc_security_group_ids = [aws_security_group.allow_nat.id]
  source_dest_check      = var.source_dest_check

  user_data = <<-EOF
        #!/bin/bash
        sysctl -w net.ipv4.ip_forward=1 /sbin/
        iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
  EOF

  tags = {
    Name = "${var.env}-NatInstance"
  }
}

# Nat SG
resource "aws_security_group" "allow_nat" {
  name        = var.name
  vpc_id      = aws_vpc.vpc.id
  description = "Allow inbound traffic"
}

## SG Rule egress
resource "aws_security_group_rule" "web_egress_allow_all" {
type              = var.web_egress_allow_all.type
  to_port           = var.web_egress_allow_all.to_port
  protocol          = var.web_egress_allow_all.protocol
  from_port         = var.web_egress_allow_all.from_port
  cidr_blocks       = var.web_egress_allow_all.cidr_blocks
  security_group_id = aws_security_group.allow_nat.id


## SG Rule ingress
resource "aws_security_group_rule" "ingress_allow_private" {
  type              = var.ingress_allow_private.type
  from_port         = var.ingress_allow_private.from_port
  to_port           = var.ingress_allow_private.to_port
  protocol          = var.ingress_allow_private.protocol
  cidr_blocks       = var.ingress_allow_private.cidr_blocks
  security_group_id = aws_security_group.allow_nat.id
}

# Route Table
## Private
### Use Main Route Table
resource "aws_default_route_table" "main-private" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block  = var.cidr_block_main_pri
    instance_id = aws_instance.nat.id
  }

  tags = {
    Name = "${var.env}-rt-main-private"
  }
}

## Public
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.cidr_block_pub
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.env}-rt-public"
  }
}

# Public Route Table Association
resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.subnet-public-1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.subnet-public-2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-3" {
  subnet_id      = aws_subnet.subnet-public-3.id
  route_table_id = aws_route_table.public.id
}
