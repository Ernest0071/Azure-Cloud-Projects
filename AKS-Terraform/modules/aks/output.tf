output "config" {
  value       = azurerm_kubernetes_cluster.aks-cluster.kube_config_raw
  description = "Kube config"
}