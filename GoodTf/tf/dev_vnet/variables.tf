variable "az_resource_group" {
  description = "Target resource group"
  type        = object({
    name     = string
    location = string
  })
  validation {
    condition = length(var.az_resource_group.name) < 90
    error_message = "AZ resource group names must use fewer than 90 characters"
  }
}

variable "vnet_name" {
    description = "Name of VNet"
    type        = string
}

variable "address_space" {
    description = "Address space of VNet"
    type        = string
}

variable "subnet_range" {
    description = "Address space of subnet"
    type        = string
}

variable "route_table_fwd_address" {
    description = "Packets sent to 0.0.0.0/0 will be forwarded to this IP address."
    type        = string
}

variable "resource_name_prefix" {
    description = "Common prefix for resources in Culligan Azure"
    type        = string
}

variable "service_name" {
    description = "Name of service to put in the Vnet"
    type        = string
}
