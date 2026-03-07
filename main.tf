resource "aws_vpc" "roboshop" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.ec2_vpc_tags
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.roboshop.id

  tags = local.ig_final_tags
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = var.public_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = true

  tags = merge (
                local.common_tags,
            { Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}" },
            var.public_subnet_tags

  )
  }


resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
                local.common_tags,
            { Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}" },
            var.private_subnet_tags

  )
  }

  resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
                local.common_tags,
            { Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}" },
            var.database_subnet_tags

  )
  }