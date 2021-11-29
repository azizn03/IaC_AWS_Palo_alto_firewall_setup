
include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("all_vars.hcl")).locals.vars
  environment                  = local.vars.environment.environment
  instance_name                = "palo-alto-firewall"
  instance_type                = "m5.xlarge"
  monitoring                   = false
  associate_public_ip_address  = true
  public-check                 = false
  private-check                = false

  
  public-nic-tags = {
    "Name" = "palo-alto-${local.environment}-NIC-public"
  }

   private-nic-tags = {
    "Name" = "palo-alto-${local.environment}-NIC-private"
  }

    routetable-private_tags = {
    "Name" = "palo-alto-${local.environment}-routetable-private"
  }



}

inputs = {
  private-nic-tags             = local.private-nic-tags
  public-nic-tags              = local.public-nic-tags
  routetable-private_tags      = local.routetable-private_tags
  instance_name                = local.instance_name
  instance_type                = local.instance_type
  monitoring                   = local.monitoring
  associate_public_ip_address  = local.associate_public_ip_address
  public-check                 = local.public-check
  private-check                = local.private-check
}