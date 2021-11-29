resource "aws_vpc" "palo-alto-vpc" {

  cidr_block           = var.cidr_block
  tags                 = var.vpc_tags
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

resource "aws_subnet" "palo-alto-subnet-management" {

  for_each          = var.subnets_management
  vpc_id            = aws_vpc.palo-alto-vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags              = var.subnet-management-tags
}
resource "aws_subnet" "palo-alto-subnet-private" {

  for_each          = var.subnets_private
  vpc_id            = aws_vpc.palo-alto-vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags              = var.subnet-private-tags
}

resource "aws_subnet" "palo-alto-subnet-public" {

  for_each          = var.subnets_public
  vpc_id            = aws_vpc.palo-alto-vpc.id
  cidr_block        = each.key
  availability_zone = each.value
  tags              = var.subnet-public-tags
}

resource "aws_internet_gateway" "palo-alto-igw" {

  vpc_id = aws_vpc.palo-alto-vpc.id
  tags   = var.igw_tags
}

# Route table: attach Internet Gateway 
resource "aws_route_table" "palo-alto-routetable-public" {
  vpc_id = aws_vpc.palo-alto-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.palo-alto-igw.id
  }
  depends_on = [
    aws_internet_gateway.palo-alto-igw
  ]
  tags = var.routetable-public_tags
}

resource "aws_route_table_association" "route-public" {
    subnet_id = flatten(data.aws_subnet_ids.palo-alto-subnet-public.ids)[0]
    route_table_id = aws_route_table.palo-alto-routetable-public.id
}


resource "aws_route_table_association" "route-management" {
    subnet_id = flatten(data.aws_subnet_ids.palo-alto-subnet-management.ids)[0]
    route_table_id = aws_route_table.palo-alto-routetable-public.id
}

resource "aws_security_group" "palo-alto-sg-management" {

  name        = "palo-alto-sg-management"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.palo-alto-vpc.id
  tags        = var.sg_management_tags

 dynamic "ingress" {
   for_each  = var.ports
   content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      cidr_blocks = [var.home_ip]
    }
 }
  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}