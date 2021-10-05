provider "azurerm" {
  version   = "=2.11.0"
	features {}  
}

resource "azurerm_resource_group" "resourcegroup" {
        name = "Hillel-EIS-TF-RG"
        location = "westeurope"
        tags = {
            project = "Homework #40 for Hillel-EIS"
        }
}

resource "azurerm_virtual_network" "network" {
    name                = "${azurerm_resource_group.resourcegroup.name}-network"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.resourcegroup.location
    resource_group_name = azurerm_resource_group.resourcegroup.name

    tags = azurerm_resource_group.resourcegroup.tags
}

esource "azurerm_subnet" "subnet" {
    name                 = "${azurerm_resource_group.resourcegroup.name}-subnet"
    resource_group_name  = azurerm_resource_group.resourcegroup.name
    virtual_network_name = azurerm_virtual_network.network.name
    address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_interface" "vm1-nic" {
    name                        = "vm1-NIC"
    location                    = azurerm_resource_group.resourcegroup.location
    resource_group_name         = azurerm_resource_group.resourcegroup.name

    ip_configuration {
        name                          = "vm1-NicConfiguration"
        subnet_id                     = "${azurerm_subnet.subnet.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "10.0.2.4"
    }

    tags = azurerm_resource_group.resourcegroup.tags
}

resource "azurerm_linux_virtual_machine" "main" {
    name                  = "UAvm1"
    location              = "westus2"
    resource_group_name   = data.azurerm_resource_group.main.name
    network_interface_ids = [azurerm_network_interface.main.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "UAvm1OSdisk"
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "OpenLogic"
        offer     = "CentOS"
        sku       = "7.5"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    admin_password = "test@123"
    disable_password_authentication = false

    tags = {
        environment = "UnixArena Terraform Demo"
    }
}



resource "azurerm_virtual_machine" "vm-1" {
  name                  = "vm1"
  location              = "${azurerm_resource_group.resourcegroup.location}"
  resource_group_name   = "${azurerm_resource_group.resourcegroup.name}"
  network_interface_ids = ["${azurerm_network_interface.vm1-nic.id}"]
  vm_size               = "Standard_B1ms"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "vm1-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "vm-1"
    admin_username = "demoadmin"
    admin_password = "$om3s3cretPassWord"
  }

  os_profile_windows_config {
      enable_automatic_upgrades = "true"
      provision_vm_agent = "true"
  }

  tags = azurerm_resource_group.resourcegroup.tags
}