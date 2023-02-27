variable "az_region" {
  description = "Target AZ region (e.g. eastus1)"
  type        = string
}

variable "app_service_plan" {
    description = "https://learn.microsoft.com/en-us/azure/app-service/overview-hosting-plans"
    type        = string
}

variable "connection_string" {
    description = "Connection string of db used by App Service"
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

variable "bu" {
    description = "Customer business unit (e.g. flg)"
    type        = string
}

variable "environment" {
    description = "Deployment tier (e.g. dev)"
    type        = string
}

variable "owner" {
    description = "Email address of the party who owns this "
    type        = string
}

variable "service_name" {
    description = "Name of hub web service"
    type        = string
}

