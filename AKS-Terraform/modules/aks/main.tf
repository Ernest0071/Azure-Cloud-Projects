# Retrieves the latest Kubernetes service version available in the specified location.
data "azurerm_kubernetes_service_versions" "current" {
  location = var.location
}

# Creates an Azure Kubernetes Service (AKS) cluster with a default node pool.
resource "azurerm_kubernetes_cluster" "aks-cluster" {
  name                = "tfpracticedev-aks-cluster"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_group_name}-cluster"
  kubernetes_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "${var.resource_group_name}-nrg"

  # Defines the default node pool for the AKS cluster.
  default_node_pool {
    name                = "defaultpool"
    vm_size             = "Standard_DS2_v2"
    zones               = [1, 2, 3]
    enable_auto_scaling = true
    max_count           = 3
    min_count           = 1
    os_disk_size_gb     = 30
    type                = "VirtualMachineScaleSets"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
    tags = {
      "nodepool-type" = "system"
      "environment"   = "prod"
      "nodepoolos"    = "linux"
    }
  }

  # Defines the service principal used to manage the AKS cluster.
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  # Defines the Linux profile for the AKS cluster.
  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }

  # Defines the network profile for the AKS cluster.
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }
}