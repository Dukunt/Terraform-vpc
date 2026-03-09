variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_cidr" {
    default =  "10.0.0.0/16"
}

variable "vpc_tags" {
    type = map
    default = {}
}

variable "ig_tags" {
    type = map
    default = {}
}

variable public_subnet_cidrs {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"]

}

variable public_subnet_tags {
    type = map
    default = {}
}

variable private_subnet_cidrs {
    type = list
    default = ["10.0.11.0/24","10.0.21.0/24"]

}

variable private_subnet_tags {
    type = map
    default = {}
}

variable database_subnet_cidrs {
    type = list
    default = ["10.0.31.0/24","10.0.41.0/24"]

}

variable database_subnet_tags {
    type = map
    default = {}
}

variable public_rt_tags {
    type = map
    default = {}
}
variable private_rt_tags {
    type = map
    default = {}
}

variable database_rt_tags {
    type = map
    default = {}
}

variable eip_tags {
    type = map
    default = {}
}

variable nat_tags {
    type = map
    default = {}
}

variable is_peerring_required {
    default = true
    type = bool
}