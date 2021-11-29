

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> v2.0"

  name                   = var.instance_name
  ami                    = data.aws_ami.palo-alto.id
  instance_type          = var.instance_type
  key_name               = var.palo-alto-ssh_key
  monitoring             = var.monitoring
  vpc_security_group_ids = [data.aws_security_group.palo-alto-sg-management.id]
  subnet_id              = flatten(data.aws_subnet_ids.palo-alto-subnet-management.ids)[0]
  associate_public_ip_address = var.associate_public_ip_address
}

resource "aws_network_interface" "public-NIC" {
  subnet_id       = flatten(data.aws_subnet_ids.palo-alto-subnet-public.ids)[0]
  security_groups = [data.aws_security_group.palo-alto-sg-management.id]
  source_dest_check = var.public-check
  tags            = var.public-nic-tags
  
  attachment {
    instance     = flatten(module.ec2_instance.id)[0]
    device_index = 1
  }
}

resource "aws_network_interface" "private-NIC" {
  subnet_id       = flatten(data.aws_subnet_ids.palo-alto-subnet-private.ids)[0]
  security_groups = [data.aws_security_group.palo-alto-sg-management.id]
  source_dest_check = var.private-check
  tags            = var.private-nic-tags
  
  attachment {
    instance     = flatten(module.ec2_instance.id)[0]
    device_index = 2
  }
}

resource "aws_route_table" "palo-alto-routetable-private" {
   vpc_id = data.aws_vpc.palo-alto-vpc.id
  route {
     cidr_block = "0.0.0.0/0"
     network_interface_id = aws_network_interface.private-NIC.id
  }
   tags = var.routetable-private_tags
 }

 resource "aws_route_table_association" "route-private" {
    subnet_id = flatten(data.aws_subnet_ids.palo-alto-subnet-private.ids)[0]
    route_table_id = aws_route_table.palo-alto-routetable-private.id
}


data "aws_ami" "palo-alto" {
  most_recent = true

  filter {
    name = "name"
    values = ["PA-VM-AWS-10.1.0*"]
  }
  owners = ["aws-marketplace"]

    filter {
    name   = "product-code"
    values = ["e9yfvyj3uag5uo5j2hjikv74n"]
  }
}

resource "tls_private_key" "pa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "palo_ssh_key" {
  key_name   = var.palo-alto-ssh_key
  public_key = tls_private_key.pa_key.public_key_openssh

  provisioner "local-exec" { 
    command = <<-EOT
      echo '${tls_private_key.pa_key.private_key_pem}' > ../../'${var.palo-alto-ssh_key}'.pem
      chmod 400 ../../'${var.palo-alto-ssh_key}'.pem
    EOT
  }
}

output "ip" {
  value = module.ec2_instance.public_ip
}
