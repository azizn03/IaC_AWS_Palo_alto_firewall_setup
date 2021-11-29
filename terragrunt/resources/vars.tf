
# JUMPBOX

variable "instance_name" {
    type = string
}

variable "instance_type" {
    type = string
}

variable "monitoring" {
    type = bool
}

variable "associate_public_ip_address" {
    type = bool  
}

variable "palo-alto-ssh_key" {
  type        = string
  default     = "palo_key"
  description = "Key-pair for PAN_OS"
}

variable "public-check" {
  type = bool
}

variable "private-check" {
  type = bool
}

variable "public-nic-tags" {
  type = map(any)
}

variable "private-nic-tags" {
  type = map(any)
}

data "aws_vpc" "palo-alto-vpc" {
  filter {
        name   = "tag:Name"
    values = ["palo-alto-*-vpc"]
    }
}

variable "routetable-private_tags" {
  type = map(any)  
}

data "aws_subnet_ids" "palo-alto-subnet-management" {
  vpc_id            = data.aws_vpc.palo-alto-vpc.id
 filter {
    name = "tag:Name"
    values = ["palo-alto-*-subnet-management"]
  }
}

data "aws_subnet_ids" "palo-alto-subnet-private" {
  vpc_id            = data.aws_vpc.palo-alto-vpc.id
 filter {
    name = "tag:Name"
    values = ["palo-alto-*-subnet-private"]
  }
}

data "aws_subnet_ids" "palo-alto-subnet-public" {
  vpc_id            = data.aws_vpc.palo-alto-vpc.id
 filter {
    name = "tag:Name"
    values = ["palo-alto-*-subnet-public"]
  }
}

data "aws_security_group" "palo-alto-sg-management" {
    filter {
        name   = "tag:Name"
    values = ["palo-alto-*-sg-management"]
    }
}