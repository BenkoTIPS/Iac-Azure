terraform {
  required_providers { 
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.0"
    }
  }
  
  required_version = ">= 0.14.9"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


resource "azurerm_resource_group" "rg" {
  name = "${var.env_name}-${var.app_name}-${var.tool}-rg"
  location = "centralus"
}

resource "azurerm_app_service_plan" "plan" {
  name                = "${var.app_name}-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "linux"
  reserved = true
  sku {
    tier = "standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "site" {
  name                = "${var.env_name}-${var.app_name}-site"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.plan.id
  app_settings = {
    EnvName = var.app_name
    FavoriteColor = "lightpink"
    MySecret = ""
    # APPLICATION_INSIGHTSKEY = azurerm_application_insights.ai.instrumentation_key
  }
  site_config  {
    dotnet_framework_version = "v6.0"
    linux_fx_version = "DOTNETCORE|6.0"
    app_command_line = "dotnet myapp.dll"
  }
}