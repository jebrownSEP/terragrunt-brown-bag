
locals {
  az_resource_group = "fjs124a124ljfk"
  az_region = "us-central"
  app_service_plan = "S1"
  virtual_network_subnet_id = "123"
  connection_string = "dkasjmf98mujf983"
  database_type = "postgres"
  bu = "gf67gh8"
  environment = "stg"
  owner = "Jay-Z"
  service_app_client_id = "vk7bgnbj"
  service_app_client_secret = "HFDHUF79382djj"
  service_identifier_uri = "api//data-service-Yew"
  az_ad_tenant_id = "HFDHUF79382djj"
  az_name_prefix = '${local.bu}-${local.environment}-${local.az_region}'
}

# Create the Windows App Service Plan
resource "azurerm_service_plan" "this" {
  name                = "${var.az_name_prefix}plan"
  location            = var.az_resource_group.location
  resource_group_name = var.az_resource_group.name
  os_type             = "Windows"
  sku_name            = var.app_service_plan
  tags                = local.tags
}

# Create the web app, pass in the App Service Plan ID
resource "azurerm_windows_web_app" "this" {
  name                      = "${var.az_name_prefix}app01"
  location                  = var.az_resource_group.location
  resource_group_name       = var.az_resource_group.name
  service_plan_id           = azurerm_service_plan.this.id
  https_only                = true
  virtual_network_subnet_id = var.virtual_network_subnet_id
  tags    = local.tags
  connection_string {
    name  = "Database-Connection-String"
    type  = var.database_type
    value = var.connection_string
  }
  site_config {
    # UPDATE first time
    # likely want this on when not on free tier
    always_on = var.environment == "prd" ? true : false
    application_stack {
        current_stack = "dotnet"
        dotnet_version = "v7.0"
    }
  }
  app_settings = {
    "APPLICATIONINSIGHTS_CONNECTION_STRING": "${azurerm_application_insights.this.connection_string}",
    "ApplicationInsightsAgent_EXTENSION_VERSION": "~2",
    "XDT_MicrosoftApplicationInsights_Mode": "recommended"
  }
}
