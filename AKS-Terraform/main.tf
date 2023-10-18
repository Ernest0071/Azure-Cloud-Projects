# Retrieves the subscription ID for the primary subscription.
data "azurerm_subscription" "primary" {
}

# Creates an Azure Resource Group with the specified name and location.
resource "azurerm_resource_group" "main" {
  name     = var.rgname
  location = var.location
}

# Creates a Service Principal with the specified name.
module "ServicePrincipal" {
  source                 = "./modules/ServicePrincipal"
  service_principal_name = var.service_principal_name

  depends_on = [
    azurerm_resource_group.main
  ]
}

# Assigns the Contributor role to the Service Principal at the subscription level.
resource "azurerm_role_assignment" "rolespn" {

  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Contributor"
  principal_id         = module.ServicePrincipal.service_principal_object_id

  depends_on = [
    module.ServicePrincipal
  ]
}

resource "null_resource" "wait_for_sp_creation" {

  provisioner "local-exec" {
    command = "sleep 120" # Sleep for 2 minutes (adjust as needed)
  }
  depends_on = [
    module.ServicePrincipal,
    module.keyvault
  ]
}

# Creates an Azure Key Vault.
module "keyvault" {
  source                      = "./modules/keyvault"
  keyvault_name               = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.rgname
  service_principal_name      = var.service_principal_name
  service_principal_object_id = module.ServicePrincipal.service_principal_object_id
  service_principal_tenant_id = module.ServicePrincipal.service_principal_tenant_id

  depends_on = [
    module.ServicePrincipal
  ]
}

# Creates an Azure Kubernetes Service (AKS) cluster.
module "aks" {
  source                 = "./modules/aks/"
  service_principal_name = var.service_principal_name
  client_id              = module.ServicePrincipal.client_id
  client_secret          = module.ServicePrincipal.client_secret
  location               = var.location
  resource_group_name    = var.rgname

  depends_on = [
    null_resource.wait_for_sp_creation
  ]

}

# Generates a local kubeconfig file for the AKS cluster.
resource "local_file" "kubeconfig" {
  depends_on = [module.aks]
  filename   = "./kubeconfig"
  content    = module.aks.config

}