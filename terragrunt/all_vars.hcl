locals {
  vars = merge(
    {
      environment = read_terragrunt_config("environment.hcl").locals
    }
  )
}