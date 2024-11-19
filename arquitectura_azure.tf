# Configura Azure con subs id
provider "azurerm" {
  features {}
  subscription_id = "d8899ee8-a6be-4926-bff3-cc777c6d0e12"

}

# Variables para no repetir
variable "resource_group_name" {
  default = "grupo-dmc-examen-srh"
}

variable "location" {
  default = "Central US"
  # Solo me deja crear clusters en esta región (?)
}


# Grupo recursos
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Storage
resource "azurerm_storage_account" "store" {
  name                     = "storedmcexamensrh"  
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#COntainers
resource "azurerm_storage_container" "container_source" {
  name                  = "source"
  storage_account_id = azurerm_storage_account.store.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_bronze" {
  name                  = "bronze"
  storage_account_id = azurerm_storage_account.store.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_silver" {
  name                  = "silver"
  storage_account_id = azurerm_storage_account.store.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_gold" {
  name                  = "gold"
  storage_account_id = azurerm_storage_account.store.id
  container_access_type = "private"
}

# # Databricks (solo el workspace)
# resource "azurerm_databricks_workspace" "dbx" {
#   name                = "dbxdmcexamensrh"
#   resource_group_name = azurerm_resource_group.rg.name
#   location            = azurerm_resource_group.rg.location
#   sku                 = "standard"
# }

resource "azurerm_databricks_workspace" "dbx" {
  name                = "dbxdmcexamensrh"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "standard"
  managed_resource_group_name = "groupnameexamensrh4"
  # no funciona sin especificar el managed_resource_group_name
}


#Datafactory
resource "azurerm_data_factory" "df" {
  name                = "dfdmcexamensrh"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}