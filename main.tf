resource "aws_vpc" "roboshop" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.ec2_vpc_tags
}