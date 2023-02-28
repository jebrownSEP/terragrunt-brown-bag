# populate this with output from setRemoteState bash script
locals {
  // TODO: update for your subscription
  subscription_id = "605a3a1c-01d3-4075-947a-8c2ad12066d7"

  app_service_plan = "B1"
  # vnet config
  address_space = "10.248.39.0/24"
  route_table_fwd_address = "10.248.0.70"

  # tag data
  bu = "nonprd-bu"
  owner= "adminOwnerEmail@sharklasers.com"
}
