#!/bin/bash

terragrunt plan -destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt/resources <<< "yes"
terragrunt destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt/resources <<< "yes"
terragrunt plan -destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt/vpc <<< "yes"
terragrunt destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt/vpc <<< "yes"
terragrunt plan -destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt <<< "yes"
terragrunt destroy --terragrunt-non-interactive --terragrunt-working-dir terragrunt <<< "yes"
