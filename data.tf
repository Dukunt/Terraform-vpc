data "aws_availability_zones" "availablezone" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}