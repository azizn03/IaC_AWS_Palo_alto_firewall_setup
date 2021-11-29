variable "cidr_block" {
  type = string
}
variable "vpc_tags" {
  type = map(string)
}
variable "enable_dns_support" {}
variable "enable_dns_hostnames" {}

variable "subnets_management" {
  type = map(string)
}
variable "subnets_public" {
  type = map(string)
}

variable "subnets_private" {
  type = map(string)
}
variable "igw_tags" {
  type = map(string)
}

variable "sg_management_tags" {
  type = map(any)
}


variable "routetable-public_tags" {
  type = map(any)
}

variable "subnet-management-tags" {
    type = map(any)
}

variable "subnet-public-tags" {
    type = map(any)
}

variable "subnet-private-tags" {
    type = map(any)
}

variable "ports" {
    type = list
}

variable "home_ip" {}

data "aws_subnet_ids" "palo-alto-subnet-management" {
  vpc_id            = aws_vpc.palo-alto-vpc.id

   filter {
    name = "tag:Name"
    values = ["palo-alto-*-subnet-management"]
  }

depends_on = [
  aws_subnet.palo-alto-subnet-management,
  aws_vpc.palo-alto-vpc
   ]
}

data "aws_subnet_ids" "palo-alto-subnet-public" {
  vpc_id            = aws_vpc.palo-alto-vpc.id

  filter {
    name = "tag:Name"
    values = ["palo-alto-*-subnet-public"]
  }

depends_on = [
  aws_subnet.palo-alto-subnet-public,
  aws_vpc.palo-alto-vpc
   ]
}