locals {
  # Automatically load account-level variables
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Extract the variables we need for easy access
  subscription_id = local.subscription_vars.locals.subscription_id

  # resource_group_name = local.subscription_vars.locals.resource_group_name
  # storage_account_name = local.subscription_vars.locals.storage_account_name
  # container_name = local.subscription_vars.locals.container_name
  # account_key = local.subscription_vars.locals.account_key
  service_name = "demo"

}

# everything that includes this file will pass into input the locals of these imported files
inputs = merge(
  local.subscription_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
  {
    service_name = local.service_name,
  }
)
