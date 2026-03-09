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

#Private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = var.private_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
                local.common_tags,
             #roboshop-dev-private-us-east-1   
            { Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}" },
            var.private_subnet_tags

  )
  }

 #database subnets
  resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidrs)
  vpc_id     = aws_vpc.roboshop.id
  cidr_block = var.database_subnet_cidrs[count.index]
  availability_zone = local.az_names[count.index]
  map_public_ip_on_launch = false

  tags = merge (
                local.common_tags,
                #roboshop-dev-database-us-east-1  
            { Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}" },
            var.database_subnet_tags

  )
  }

  #route tables
  resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge (
                local.common_tags,
                #roboshop-dev-database-us-east-1  
            { Name = "${var.project}-${var.environment}-public" },
            var.public_rt_tags
     
  )
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge (
                local.common_tags,
                #roboshop-dev-private  
            { Name = "${var.project}-${var.environment}-private" },
            var.private_rt_tags
     
  )
}

resource "aws_route_table" "database_rt" {
  vpc_id = aws_vpc.roboshop.id

  tags = merge (
                local.common_tags,
                #roboshop-dev-database
            { Name = "${var.project}-${var.environment}-database" },
            var.database_rt_tags
     
  )
}

#creating route for publicsubnet
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

# creating Elastic Ip
resource "aws_eip" "nat_eip" {
  domain                    = "vpc"
  tags = merge (
                local.common_tags,
                #roboshop-dev-database
            { Name = "${var.project}-${var.environment}-nat" },
            var.eip_tags
     
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id

  tags =  merge (
                local.common_tags,
                #roboshop-dev-database
            { Name = "${var.project}-${var.environment}-nat" },
            var.nat_tags 
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database_rt.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "public_rta" {
  count = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rta" {
  count = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "database_rta" {
  count = length(var.database_subnet_cidrs)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database_rt.id
}
