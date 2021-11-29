# Include all settings from the root terragrunt.hcl file
include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("all_vars.hcl")).locals.vars

  name                = "palo-alto-vpc"
  environment         = local.vars.environment.environment
  cidr                = "172.16.0.0/16"
  ports = [22, 80, 443]

 subnets_management = {
      "172.16.1.0/24" = "us-east-1a"
    }

  subnets_private = {
      "172.16.2.0/24" = "us-east-1a"
    }

  subnets_public = {
      "172.16.3.0/24" = "us-east-1a"
    }  

  vpc_tags = {
    "Name" = "palo-alto-${local.environment}-vpc"
  }

  igw_tags = {
    "Name" = "palo-alto-${local.environment}-igw"
  }

  routetable-public_tags = {
    "Name" = "palo-alto-${local.environment}-routetable-public"
  }

  sg_management_tags = {
    "Name" = "palo-alto-${local.environment}-sg-management"
  }
  
  subnet-management-tags = {
    "Name" = "palo-alto-${local.environment}-subnet-management"
  }

  subnet-private-tags = {
    "Name" = "palo-alto-${local.environment}-subnet-private"
  }

  subnet-public-tags = {
    "Name" = "palo-alto-${local.environment}-subnet-public"
  }

}
inputs = {
  
  ports                 = local.ports
  vpc_name              = local.name
  subnets_public        = local.subnets_public
  subnets_private       = local.subnets_private
  subnets_management    = local.subnets_management
  vpc_tags              = local.vpc_tags
  igw_tags              = local.igw_tags
  sg_management_tags     = local.sg_management_tags
  routetable-public_tags = local.routetable-public_tags
  subnet-management-tags = local.subnet-management-tags
  subnet-private-tags   = local.subnet-private-tags
  subnet-public-tags    = local.subnet-public-tags
  cidr_block            = local.cidr
  enable_dns_support    = true
  enable_dns_hostnames  = true
  environment           = local.environment
}

