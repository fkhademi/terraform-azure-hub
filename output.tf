output "vnet" {
  description = "Azure VNET and all its attributes"
  value       = azurerm_virtual_network.default
}

output "nva1" {
  description = "Azure NVA1 Subnet and all its attributes"
  value       = azurerm_subnet.nva1
}

output "nva1-lan" {
  description = "Azure NVA1 LAN Subnet and all its attributes"
  value       = azurerm_subnet.nva1-lan
}

output "nva2" {
  description = "Azure NVA2 Subnet and all its attributes"
  value       = azurerm_subnet.nva2
}

output "nva2-lan" {
  description = "Azure NVA2 LAN Subnet and all its attributes"
  value       = azurerm_subnet.nva2-lan
}

output "ars" {
  description = "Azure ARS Subnet and all its attributes"
  value       = azurerm_subnet.ars
}

output "lb" {
  # lb_ip        = azurerm_lb.default.frontend_ip_configuration[0].private_ip_address,
  value = azurerm_lb.default
}
