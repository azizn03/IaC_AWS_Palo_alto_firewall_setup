#!/bin/bash

terragrunt plan --terragrunt-non-interactive --terragrunt-working-dir terragrunt <<< "yes"
terragrunt apply --terragrunt-non-interactive --terragrunt-working-dir terragrunt <<< "yes"
terragrunt plan --terragrunt-non-interactive --terragrunt-working-dir terragrunt/vpc <<< "yes"
terragrunt apply --terragrunt-non-interactive --terragrunt-working-dir terragrunt/vpc <<< "yes"
terragrunt plan --terragrunt-non-interactive --terragrunt-working-dir terragrunt/resources <<< "yes"
terragrunt apply --terragrunt-non-interactive --terragrunt-working-dir terragrunt/resources <<< "yes"