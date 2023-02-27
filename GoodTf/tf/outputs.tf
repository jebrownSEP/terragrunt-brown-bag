output "webapp_url" {
    value = module.windows_webapi.webapp_url
}
output "scope" {
    value = local.svc_identifier_uri
}
output "service_application_id" {
    value = azuread_application.authorized.application_id
}
output "tenant_id" {
    value = data.azuread_client_config.current.tenant_id
}
# client secret is in file