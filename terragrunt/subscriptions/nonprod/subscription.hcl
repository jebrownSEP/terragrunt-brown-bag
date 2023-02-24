# populate this with output from setRemoteState bash script
locals {
  subscription_id = "ada803dc-8328-4262-9d7a-70e4ce006ac8"

  app_service_plan = "B1"
  # vnet config
  address_space = "10.254.38.0/24"
  route_table_fwd_address = "10.254.0.70"
}
