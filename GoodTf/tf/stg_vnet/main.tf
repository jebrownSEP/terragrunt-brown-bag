# stg

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  location            = var.az_resource_group.location
  resource_group_name = var.az_resource_group.name
  tags                = var.vnet_tags
}

resource "azurerm_subnet" "this" {
  name                 = "${var.resource_name_prefix}-subnet-${var.service_name}"
  resource_group_name  = var.az_resource_group.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.subnet_range]

  delegation {
    name = "stg-${var.service_name}"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_route_table" "this" {
  name                = "${var.resource_name_prefix}-routetable-${var.service_name}"
  location            = var.az_resource_group.location
  resource_group_name = var.az_resource_group.name

  route {
    name                   = "culligan-db"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.route_table_fwd_address
  }
}

resource "azurerm_subnet_route_table_association" "this" {
  subnet_id      = azurerm_subnet.this.id
  route_table_id = azurerm_route_table.this.id
}

output "subnet_id" {
  value = azurerm_subnet.this.id
}
