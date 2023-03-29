resource "azurerm_virtual_network" "default" {
  name                = "${var.projectname}-vnet"
  location            = var.region
  resource_group_name = var.rg_name
  address_space       = [var.cidr]
}

resource "azurerm_subnet" "ars" {
  name                 = "RouteServerSubnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 3, 0)]
}

resource "azurerm_subnet" "lb" {
  name                 = "${var.projectname}-lb-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 4, 2)]
}

resource "azurerm_subnet" "nva1" {
  name                 = "${var.projectname}-nva1-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 4, 3)]
}

resource "azurerm_subnet" "nva2" {
  name                 = "${var.projectname}-nva2-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 4, 4)]
}

resource "azurerm_subnet" "nva1-lan" {
  name                 = "${var.projectname}-nva1-lan-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 4, 5)]
}


resource "azurerm_subnet" "nva2-lan" {
  name                 = "${var.projectname}-nva2-lan-subnet"
  virtual_network_name = azurerm_virtual_network.default.name
  resource_group_name  = var.rg_name
  address_prefixes     = [cidrsubnet(var.cidr, 4, 6)]
}

# RTB associaations
resource "azurerm_route_table" "lb" {
  name                = "${var.projectname}-lb-rtb"
  location            = var.region
  resource_group_name = var.rg_name

  route {
    name                   = "default"
    address_prefix         = var.onprem_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.avx_tgw_bgpolan_ip
  }
}

resource "azurerm_subnet_route_table_association" "lb" {
  subnet_id      = azurerm_subnet.lb.id
  route_table_id = azurerm_route_table.lb.id
}

resource "azurerm_route_table" "nva1" {
  name                = "${var.projectname}-nva1-rtb"
  location            = var.region
  resource_group_name = var.rg_name

  route {
    name                   = "default"
    address_prefix         = var.onprem_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.avx_tgw_bgpolan_ip
  }
}

resource "azurerm_subnet_route_table_association" "nva1" {
  subnet_id      = azurerm_subnet.nva1.id
  route_table_id = azurerm_route_table.nva1.id
}

resource "azurerm_route_table" "nva2" {
  name                = "${var.projectname}-nva2-rtb"
  location            = var.region
  resource_group_name = var.rg_name

  route {
    name                   = "default"
    address_prefix         = var.onprem_cidr
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.avx_tgw_hagw_bgpolan_ip
  }
}

resource "azurerm_subnet_route_table_association" "nva2" {
  subnet_id      = azurerm_subnet.nva2.id
  route_table_id = azurerm_route_table.nva2.id
}




#####################
### ILB ###
#####################

resource "azurerm_lb" "default" {
  name                = "${var.projectname}-ilb"
  location            = var.region
  resource_group_name = var.rg_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name      = "${var.projectname}-frontend-ip"
    subnet_id = azurerm_subnet.lb.id
  }
}

resource "azurerm_lb_probe" "default" {
  loadbalancer_id = azurerm_lb.default.id
  name            = "ssh-running-probe"
  port            = 22
}

resource "azurerm_lb_backend_address_pool" "default" {
  name            = "${var.projectname}-backend-address-pool"
  loadbalancer_id = azurerm_lb.default.id
}

resource "azurerm_lb_rule" "default" {
  loadbalancer_id                = azurerm_lb.default.id
  name                           = "LBRule"
  protocol                       = "All"
  frontend_port                  = 0
  backend_port                   = 0
  frontend_ip_configuration_name = azurerm_lb.default.frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.default.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.default.id]
}

resource "azurerm_lb_backend_address_pool_address" "backend1" {
  name                    = "${var.projectname}-NVA1-LAN"
  backend_address_pool_id = azurerm_lb_backend_address_pool.default.id
  virtual_network_id      = azurerm_virtual_network.default.id
  ip_address              = var.nva1_lan_ip
}

resource "azurerm_lb_backend_address_pool_address" "backend2" {
  name                    = "${var.projectname}-NVA2-LAN"
  backend_address_pool_id = azurerm_lb_backend_address_pool.default.id
  virtual_network_id      = azurerm_virtual_network.default.id
  ip_address              = var.nva2_lan_ip
}
