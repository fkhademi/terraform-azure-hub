variable "projectname" {
  description = "Name to prefix all of the Azure resources"
}

variable "region" {
  description = "Azure region to deploy the resources in"
}

variable "rg_name" {
  description = "Resource Group name to put all resources in"
}

variable "cidr" {
  description = "CIDR range to assign to the VNET Hub"
}

variable "onprem_cidr" {
  description = "OnPrem CIDR to program in the LB Route Table"
  default     = "10.1.0.0/16"
}

variable "avx_tgw_bgpolan_ip" {
  # module.azure_transit.transit_gateway.bgp_lan_ip_list[0]
  default = "Aviatrix Transit GW LAN IP"
}

variable "avx_tgw_hagw_bgpolan_ip" {
  # module.azure_transit.transit_gateway.ha_bgp_lan_ip_list[0]
  default = "Aviatrix Transit HAGW LAN IP"
}

variable "nva1_lan_ip" {
  default = "NVA1 LAN IP"
  # module.nva1.lan_nic.private_ip_address
}

variable "nva2_lan_ip" {
  default = "NVA2 LAN IP"
  # module.nva2.lan_nic.private_ip_address
}
