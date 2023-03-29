# terraform-azure-hub

Generic terraform module for deploying an Azure Hub with Load Balancer. 

### Usage Example
```
  source = "git::https://github.com/fkhademi/terraform-azure-hub.git"

  projectname             = "frey"
  region                  = "West Europe"
  rg_name                 = "rg-av-frey-899789"
  cidr                    = "192.168.1.0/24"
  onprem_cidr             = "10.1.0.0/16"
  avx_tgw_bgpolan_ip      = "192.168.2.200"
  avx_tgw_hagw_bgpolan_ip = "192.168.2.220"
  nva1_lan_ip             = "192.168.1.100"
  nva2_lan_ip             = "192.168.1.120"
}

```

### Variables
The following variables are required:

key | value
:--- | :---
projectname | Name to prefix Azure resources
region | Azure region
rg_name | Resource Group name where resources should be deployed
cidr | CIDR for the VNET Hub
onprem_cidr | OnPrem CIDR to program in the LB Route Table
avx_tgw_bgpolan_ip | IP of the Aviatrix Transit LAN interface
avx_tgw_hagw_bgpolan_ip | IP of the Aviatrix Transit HAGW LAN interface
nva1_lan_ip | NVA1 LAN IP
nva2_lan_ip | NVA2 LAN IP


### Outputs
This module will return the following outputs:

key | description
:---|:---

vm | The created VM as an object with all of it's attributes. This was created using the azurerm_virtual_machine resource.
nic | The created NIC as an object with all of it's attributes. This was created using the azurerm_network_interface resource.
public_ip | Public ip and its attributes