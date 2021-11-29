locals {
  base            = element(split("-", local.environment), 0)
  environment     = "dev"
}