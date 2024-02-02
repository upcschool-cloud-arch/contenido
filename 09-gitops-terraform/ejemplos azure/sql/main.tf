#objeto para generar nombres aleatorios
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

#creación del resource group
resource "azurerm_resource_group" "rg" {
  name     = random_pet.rg_name.id
  location = var.resource_group_location
}

#Generar nombres aleatorios para las dos instancias de SQL
resource "random_pet" "azurerm_mssql_server_name" {
  prefix = "sql"
}

resource "random_pet" "azurerm_mssql_server_name2" {
  prefix = "sql"
}

#Generar contraseña aleatoria para el usuario admin
resource "random_password" "admin_password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

locals {
  admin_password = try(random_password.admin_password[0].result, var.admin_password)
}

#Creación de las dos instancias de SQL
resource "azurerm_mssql_server" "server" {
  name                         = random_pet.azurerm_mssql_server_name.id
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"

}

resource "azurerm_mssql_server" "server2" {
  name                         = random_pet.azurerm_mssql_server_name2.id
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.resource_group_location2
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"

}

#Creación de las reglas de firewall para las dos instancias de SQL
#Permitirán el acceso a las instancias de SQL desde los rangos de IPs definidos por las variables
# sql_public_ip_allow_start y sql_public_ip_allow_stop
resource "azurerm_mssql_firewall_rule" "main" {
    count                       = "${length(var.sql_public_ip_allow_start)}"

    name                        = "${azurerm_mssql_server.server.name}-firewall-${count.index}"
    server_id                   = azurerm_mssql_server.server.id
    start_ip_address            = "${element(var.sql_public_ip_allow_start, count.index)}"
    end_ip_address              = "${element(var.sql_public_ip_allow_stop, count.index)}"
}

resource "azurerm_mssql_firewall_rule" "main2" {
    count                       = "${length(var.sql_public_ip_allow_start)}"

    name                        = "${azurerm_mssql_server.server2.name}-firewall-${count.index}"
    server_id                 = azurerm_mssql_server.server2.id
    start_ip_address            = "${element(var.sql_public_ip_allow_start, count.index)}"
    end_ip_address              = "${element(var.sql_public_ip_allow_stop, count.index)}"
}

#Creación de la base de datos
resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id

  #Definición de las políticas de retención de backups
  long_term_retention_policy {
    weekly_retention = "P5W"
    monthly_retention = "P3M"
  }
  short_term_retention_policy {
    retention_days = 14
    backup_interval_in_hours = 24
  }
}

#Creación del failover group. Define la instancia primaria, la instancia a la que hacemos la réplica (partner_server) 
#y la política de failover automático
resource "azurerm_mssql_failover_group" "failover" {
  name      = var.failovergroup_name
  server_id = azurerm_mssql_server.server.id
  databases = [
    azurerm_mssql_database.db.id
  ]

  partner_server {
    id = azurerm_mssql_server.server2.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 80
  }
}