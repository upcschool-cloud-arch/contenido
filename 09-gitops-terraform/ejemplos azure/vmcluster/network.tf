#Creación de las redes
module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg.name
  version             = "5.2.0"
  subnet_prefixes     = var.subnet_ranges
  subnet_names        = var.subnet_names
  use_for_each        = true
  depends_on          = [azurerm_resource_group.rg]
}

#Ip  pública que se asociará al balanceador
resource "azurerm_public_ip" "examplepip" {
  name                = "pip-${var.names_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku = "Standard"
}

#Creación del balanceador, lo asociamos a la ip pública recién creada
resource "azurerm_lb" "examplelb" {
  name                = "lb-${var.names_suffix}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name
  sku = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.examplepip.id
  }
}

#Address pool del balanceador
resource "azurerm_lb_backend_address_pool" "examplebackendaddpool" {
  name            = "addpool-${var.names_suffix}"
  loadbalancer_id = azurerm_lb.examplelb.id
}

#Objeto que sirve para comprobar el estado del balanceador
resource "azurerm_lb_probe" "exampleprobe" {
  name                = "lbprobe-${var.names_suffix}"
  loadbalancer_id     = azurerm_lb.examplelb.id
  port                = 80
}

#regla del balanceador, que se encarga de enrutar el tráfico hacia las máquinas virtuales
resource "azurerm_lb_rule" "examplelbrule" {
  loadbalancer_id                = azurerm_lb.examplelb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.exampleprobe.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.examplebackendaddpool.id]
}

#Array de NICs que serán añadidas a las VMs
resource "azurerm_network_interface" "exampleinterface" {
  count               = var.numberofnodes
  name                = "nic-${var.names_suffix}-${count.index}"
  location            = var.resource_group_location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.network.vnet_subnets[0]
    private_ip_address_allocation = "Dynamic"
  }
}

#asociación entre el pool de direcciones y las interfaces de red de las máquinas virtuales
resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count = 3
  network_interface_id    = azurerm_network_interface.exampleinterface[count.index].id
  ip_configuration_name = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.examplebackendaddpool.id
}

# Create Network Security Group and rules that will be attached to the VM
resource "azurerm_network_security_group" "vms_nsg" {
  name                = "nsg-${var.names_suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Connect the security group to the vm's network interface
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  count = 3
  network_interface_id      = azurerm_network_interface.exampleinterface[count.index].id
  network_security_group_id = azurerm_network_security_group.vms_nsg.id
}