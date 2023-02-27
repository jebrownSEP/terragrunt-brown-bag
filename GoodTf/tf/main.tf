locals {
    azurerm_tags = {
        environment = var.environment
        bu = var.bu
        owner = var.owner
    }
    azad_tags = [
        "environment=${var.environment}",
        "bu=${var.bu}",
        "owner=${var.owner}",
    ]
    service_name = "demo"

    # There is one VNet for each subscription: nonprod and prod
    nonprod_vnet_name = "${var.bu}-${var.az_region}-nonprodvnet-${var.service_name}"
    prod_vnet_name = "${var.bu}-${var.az_region}-prodvnet-${var.service_name}"
    subnet_id = var.environment == "prd" ? module.prd_vnet[0].subnet_id : var.environment == "stg" ? module.stg_vnet[0].subnet_id : module.dev_vnet[0].subnet_id

    stg_resource_group_name = "${var.bu}-${var.az_region}-stg-${var.service_name}"
    resource_name_prefix = "${var.bu}-${var.az_region}-${var.environment}-gajlj"

    svc_identifier_uri = "api://${local.resource_name_prefix}-${var.service_name}"
}

# Create the resource group
resource "azurerm_resource_group" "this" {

  name     = "${var.bu}-${var.az_region}-${var.environment}-${var.service_name}"
  location = var.az_region
  tags     = local.azurerm_tags
}



module "dev_vnet" {
    count = var.environment == "dev" ? 1 : 0
    source = "./dev_vnet"

    az_resource_group = {
        # The nonprod envs share a VNet. The VNet is deployed to the stg resource group.
        name = local.stg_resource_group_name
        location = var.az_region
    }
    vnet_name = local.nonprod_vnet_name
    address_space = var.address_space
    subnet_range = var.subnet_range
    resource_name_prefix = local.resource_name_prefix
    service_name = var.service_name
    route_table_fwd_address = var.route_table_fwd_address
    # no vnet tags here because we are using an existing VNet
}

module "stg_vnet" {
    count = var.environment == "stg" ? 1 : 0
    source = "./stg_vnet"

    az_resource_group = {
        name = azurerm_resource_group.this.name
        location = azurerm_resource_group.this.location
    }
    vnet_name = local.nonprod_vnet_name
    address_space = var.address_space
    subnet_range = var.subnet_range
    resource_name_prefix = local.resource_name_prefix
    service_name = var.service_name
    vnet_tags = local.azurerm_tags
    route_table_fwd_address = var.route_table_fwd_address
}

module "prd_vnet" {
    count = var.environment == "prd" ? 1 : 0
    source = "./prd_vnet"

    az_resource_group = {
        name = azurerm_resource_group.this.name
        location = azurerm_resource_group.this.location
    }
    vnet_name = local.prod_vnet_name
    address_space = var.address_space
    subnet_range = var.subnet_range
    resource_name_prefix = local.resource_name_prefix
    service_name = var.service_name
    vnet_tags = local.azurerm_tags
    route_table_fwd_address = var.route_table_fwd_address
}

data "azuread_client_config" "current" {
}

resource "azuread_application" "authorized" {

  display_name = "${local.resource_name_prefix}-${var.service_name}-authorized"
  owners       = [data.azuread_client_config.current.object_id]
  tags = local.azad_tags
}

resource "azuread_application_password" "authorized" {
  application_object_id = azuread_application.authorized.object_id
}

resource "azuread_application" "authorizer" {

  display_name = "${local.resource_name_prefix}-${var.service_name}-authorizer"
  identifier_uris  = [local.svc_identifier_uri]
  owners = [data.azuread_client_config.current.object_id]
  tags = local.azad_tags
}
resource "azuread_application_password" "authorizer" {
  application_object_id = azuread_application.authorizer.object_id
}

resource "azuread_service_principal" "this" {
  application_id               = azuread_application.authorizer.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

module "windows_webapi" {
    source = "./windows_webapi"
    az_region = var.az_region

    az_name_prefix =  "${var.bu}${var.az_region}${var.environment}${var.service_name}"
    app_service_plan = var.app_service_plan
    connection_string = var.connection_string
    database_type = "SQLServer"
    bu = var.bu
    environment = var.environment
    owner = var.owner
    az_resource_group = {
        name = azurerm_resource_group.this.name
        location = azurerm_resource_group.this.location
    }
    service_app_client_id = azuread_application.authorizer.application_id
    service_app_client_secret = azuread_application_password.authorizer.value
    service_identifier_uri = local.svc_identifier_uri
    az_ad_tenant_id = data.azuread_client_config.current.tenant_id
    virtual_network_subnet_id = local.subnet_id
}

resource "local_file" "authorized_app_secret" {
    content  = azuread_application_password.authorized.value
    filename = "${path.module}/authorized_app_secret.txt"
}
