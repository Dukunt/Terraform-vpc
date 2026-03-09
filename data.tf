data "aws_availability_zones" "availablezone" {
  state = "available"
}

resource "aws_vpc" "default" {
  default = true
}