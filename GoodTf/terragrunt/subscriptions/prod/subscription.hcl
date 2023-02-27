# populate this with output from setRemoteState bash script
locals {
  subscription_id = "b35f8c21-ac2b-49ae-9f41-93d3f19290bd"

  app_service_plan = "S1"
  # vnet config
  address_space = "10.254.38.0/24"
  route_table_fwd_address = "10.254.0.70"

  # tag data
  bu = "prd-bu"
  owner= "adminOwnerEmail@sharklasers.com"
}
