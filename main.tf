##### 1. Create Resource Group #####
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-${var.name}-RG"
  location = "West Europe"
}


##### 2.1 Create first Virtual Network #####
resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-${var.name}-Network-1"
  address_space       = ["10.0.0.0/23"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

   depends_on = ["azurerm_resource_group.main"]
}
##### 2.2 Create second Virtual Network #####
resource "azurerm_virtual_network" "vnet2" {
  name                = "${var.prefix}-${var.name}-Network-2"
  address_space       = ["10.0.2.0/23"]
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

   depends_on = ["azurerm_resource_group.main"]
}


##### 3.1 Create first Subnet #####
resource "azurerm_subnet" "sub1" {
  name                 = "${var.prefix}-${var.name}-SubNet-1"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  address_prefix       = "10.0.0.0/24"

  depends_on = ["azurerm_resource_group.main"]
}
##### 3.2 Create second Subnet #####
resource "azurerm_subnet" "sub2" {
  name                 = "${var.prefix}-${var.name}-SubNet-2"
  resource_group_name  = "${azurerm_resource_group.main.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet2.name}"
  address_prefix       = "10.0.2.0/24"

  depends_on = ["azurerm_resource_group.main"]
}


##### 4.1 Create Security Group and Allow 22 port #####
resource "azurerm_network_security_group" "netsecgr" {
    name = "${var.prefix}-${var.name}-SecurityGroup"
    location            = "${azurerm_resource_group.main.location}"
    resource_group_name = "${azurerm_resource_group.main.name}"
    security_rule {
        name = "ssh"
        priority = 100
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_address_prefix = "*"
        source_port_range = "*"
        destination_address_prefix = "*"
        destination_port_ranges = ["22"]
    }
}
##### 4.2 Associate Subnets to Security Group #####
resource "azurerm_subnet_network_security_group_association" "secgrass1" {
  subnet_id                 = "${azurerm_subnet.sub1.id}"
  network_security_group_id = "${azurerm_network_security_group.netsecgr.id}"
}
resource "azurerm_subnet_network_security_group_association" "secgrass2" {
  subnet_id                 = "${azurerm_subnet.sub2.id}"
  network_security_group_id = "${azurerm_network_security_group.netsecgr.id}"
}


##### 5 Configure Perring between VNets #####
resource "azurerm_virtual_network_peering" "VnePerring_1_to_2" {
  name                      = "peer_a2b"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet1.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet2.id}"
}
resource "azurerm_virtual_network_peering" "VnePerring_2_to_1" {
  name                      = "peer_b2a"
  resource_group_name       = "${azurerm_resource_group.main.name}"
  virtual_network_name      = "${azurerm_virtual_network.vnet2.name}"
  remote_virtual_network_id = "${azurerm_virtual_network.vnet1.id}"
}


##### 6 Create first Virtual Machine "vm1" #####
resource "azurerm_linux_virtual_machine" "vm1" {
  name                  = "vm1"  
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = [azurerm_network_interface.nic-1.id]
  size                  = "Standard_B1s"
  admin_username        = "hillel"
  admin_password        = "Pa55w.rd"
  disable_password_authentication = false

  source_image_reference {
    publisher =  "OpenLogic"
    offer     = "CentOS"
    sku       = "8_3"
    version   = "latest"
  }

  os_disk {
    caching                   = "ReadWrite"
    name                      = "OsDiskVM1"
    storage_account_type      = "Standard_LRS"
  }
}
resource "azurerm_network_interface" "nic-1" {
  name                = "${var.prefix}-nic-1"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "tfconfig-1"
    subnet_id                     = "${azurerm_subnet.sub1.id}"
     private_ip_address_allocation = "Static"
	   private_ip_address = "10.0.0.10"
	   public_ip_address_id = "${azurerm_public_ip.pubip1.id}"
  }
}
##### 6.C Create Puclic IP #####
resource "azurerm_public_ip" "pubip1" {
  name                = "${var.prefix}-pubip1"
  resource_group_name = "${azurerm_resource_group.main.name}"
  location            = "${azurerm_resource_group.main.location}"
  allocation_method   = "Dynamic"
}
##### 6.D Create "A" Recordc for "vm1" to Private DNS Zone #####
resource "azurerm_private_dns_a_record" "vm1" {
  name                = "vm1"
  zone_name           = "${azurerm_private_dns_zone.dns.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  ttl                 = 300
  records             = ["10.0.0.10"]
}


##### 7 Create socond Virtual Machine "vm2" #####
resource "azurerm_linux_virtual_machine" "vm2" {
  name                  = "vm2"  
  location              = "${azurerm_resource_group.main.location}"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  network_interface_ids = [azurerm_network_interface.nic-2.id]
  size                  = "Standard_B1s"
  admin_username        = "hillel"
  admin_password        = "Pa55w.rd"
  disable_password_authentication = false

  source_image_reference {
    publisher =  "OpenLogic"
    offer     = "CentOS"
    sku       = "8_3"
    version   = "latest"
  }

  os_disk {
    caching                   = "ReadWrite"
    name                      = "OsDiskVM2"
    storage_account_type      = "Standard_LRS"
  }
  
}
resource "azurerm_network_interface" "nic-2" {
  name                = "${var.prefix}-nic-2"
  location            = "${azurerm_resource_group.main.location}"
  resource_group_name = "${azurerm_resource_group.main.name}"

  ip_configuration {
    name                          = "tfconfig-2"
    subnet_id                     = "${azurerm_subnet.sub2.id}"
     private_ip_address_allocation = "Static"
	   private_ip_address = "10.0.2.10"
	}
}
#### 7.D Create "A" Recordc for "vm2" to Private DNS Zone #####
resource "azurerm_private_dns_a_record" "vm2" {
  name                = "vm2"
  zone_name           = "${azurerm_private_dns_zone.dns.name}"
  resource_group_name = "${azurerm_resource_group.main.name}"
  ttl                 = 300
  records             = ["10.0.2.10"]
}


##### 8 Create Private DNS Zone #####
resource "azurerm_private_dns_zone" "dns" {
  name                = "${var.prefix}-${var.name}-private-dns.com"
  resource_group_name = "${azurerm_resource_group.main.name}"

}


##### 9 Associate DNS Zone with VNets #####
resource "azurerm_private_dns_zone_virtual_network_link" "netlink1" {
  name                  = "${var.prefix}-${var.name}-network-link1"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  private_dns_zone_name = "${azurerm_private_dns_zone.dns.name}"
  virtual_network_id    = "${azurerm_virtual_network.vnet1.id}"
}
resource "azurerm_private_dns_zone_virtual_network_link" "netlink2" {
  name                  = "${var.prefix}-${var.name}-network-link2"
  resource_group_name   = "${azurerm_resource_group.main.name}"
  private_dns_zone_name = "${azurerm_private_dns_zone.dns.name}"
  virtual_network_id    = "${azurerm_virtual_network.vnet2.id}"
}