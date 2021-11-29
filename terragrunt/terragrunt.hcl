locals {
  aws_region          = get_env("REGION", "us-east-1")
  service_name        = "palo-alto"
  environment         = "dev"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"


}
EOF
}

remote_state {
  backend = "s3"
   generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
      encrypt        = true
      region         = "us-east-1"
      bucket         = "terraform-state-${local.service_name}-${local.environment}-HAFFA"
      key            = "terraform/${local.service_name}/${path_relative_to_include()}/terraform.tfstate"
      dynamodb_table = "${local.service_name}-${local.environment}-locks"
      acl            = "bucket-owner-full-control"
    }
}
