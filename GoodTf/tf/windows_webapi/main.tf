locals {
    tags = {
        environment = var.environment
        bu = var.bu
        owner = var.owner
    }
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.az_name_prefix}workspace"
  location            = var.az_region
  resource_group_name = var.az_resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "this" {
  name                = "${var.az_name_prefix}appinsights"
  location            = var.az_region
  resource_group_name = var.az_resource_group.name
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
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

    # To add additional features, add the sections below (NOTE: I have not tested using these configurations, just enabling them)

    # Profiler
    # "APPINSIGHTS_PROFILERFEATURE_VERSION": "1.0.0",
    # "DiagnosticServices_EXTENSION_VERSION": "~3",

    # Snapshot debugger
    # "APPINSIGHTS_SNAPSHOTFEATURE_VERSION": "1.0.0",
    # with local variables
    # "SnapshotDebugger_EXTENSION_VERSION": "~1",
    # "InstrumentationEngine_EXTENSION_VERSION": "~1",


    # SQL Commands
    # "XDT_MicrosoftApplicationInsights_BaseExtensions": "~1",
    # "InstrumentationEngine_EXTENSION_VERSION": "~1",  # repeated from above
  }
}

data "azurerm_client_config" "current" {
}

resource "azapi_update_resource" "set_authv2" {
  name        = "authsettingsV2"
  type        = "Microsoft.Web/sites/config@2020-12-01"
  parent_id   = azurerm_windows_web_app.this.id

  body = jsonencode({
    properties = {
            platform = {
            enabled = true,
            runtimeVersion = "~1"
            },
            globalValidation = {
            requireAuthentication = true,
            unauthenticatedClientAction = "Return401"
            },
            identityProviders = {
            azureActiveDirectory = {
                registration = {
                openIdIssuer = "https://sts.windows.net/${var.az_ad_tenant_id}/",
                clientId = var.service_app_client_id
                },
                validation = {
                allowedAudiences = [
                    var.service_identifier_uri
                ]
                }
            },
            google = {
                validation = {
                allowedAudiences = [
                    var.service_identifier_uri
                ]
                }
            },
            legacyMicrosoftAccount = {
                validation = {
                allowedAudiences = [
                    var.service_identifier_uri
                ]
                }
            }
            },
            login = {
            tokenStore = {
                enabled = true,
                tokenRefreshExtensionHours = 72
            },
            preserveUrlFragmentsForLogins = false
            }
        }
    })
}
