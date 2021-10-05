provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}

variable "subscription_id" { description = "value" }

variable "tenant_id" { description = "value" }

variable "name" { default = "EIS" }

variable "location" { default = "West Europe" }

variable "prefix" { default = "TF" }
