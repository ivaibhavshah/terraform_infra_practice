variable "vpc_cidr" {
    description = "VPC's CIDR Block"
}

variable "public_subnets_cidr" {
    description = "Public subnet CIDR Block"
}
variable "private_subnets_cidr" {
    description = "Private subnet CIDR Block"
}

variable "availability_zones" {
    description = "list of azs"
}