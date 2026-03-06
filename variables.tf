varirable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_cidr" {
    default =  "10.0.0.0/16"
}

variabe "vpc_tags" {
    type = map
    default = {}
}