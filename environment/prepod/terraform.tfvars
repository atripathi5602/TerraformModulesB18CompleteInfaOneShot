
rgs = {
  rg = {
    name     = "rg-prepod"
    location = "Central India"
  }
}

vNet = {
  vnet = {
    name                = "prepod-Vnet"
    resource_group_name = "rg-prepod"
    location            = "Central India"
    address_space       = ["10.0.0.0/16"]
  }
}

key_vault = {
  kv1 = {
    name                        = "prepod-key-vault-1801"
    resource_group_name         = "rg-prepod"
    location                    = "Central India"
    sku_name                    = "standard"
    soft_delete_retention_days  = 7
    purge_protection_enabled    = false
    enabled_for_disk_encryption = true
    secret_permissions          = ["Get", "List", "Set", "Delete", "Purge"]

    secrets = {
      vm_admin_username = {
        name  = "vm-admin-username"
        value = "useranu"
      }

      vm_admin_password = {
        name  = "vm-admin-password"
        value = "Anurag@1234"
      }
    }
  }
}

subnets = {
  frontend_subnet = {
    name                = "frontend-subnet"
    resource_group_name = "rg-prepod"
    VnetName            = "prepod-Vnet"
    address_prefixes    = ["10.0.1.0/24"]

  }

  backend_subnet = {
    name                = "backend-subnet"
    resource_group_name = "rg-prepod"
    VnetName            = "prepod-Vnet"
    address_prefixes    = ["10.0.2.0/24"]
  }

  application_gateway_subnet = {
    name                = "application-gateway-subnet"
    resource_group_name = "rg-prepod"
    VnetName            = "prepod-Vnet"
    address_prefixes    = ["10.0.3.0/24"]
  }
}

pip = {
  pip1 = {
    name                = "front-end-pip"
    resource_group_name = "rg-prepod"
    location            = "Central India"
  }

  pip2 = {
    name                = "back-end-pip"
    resource_group_name = "rg-prepod"
    location            = "Central India"
  }

  pip3 = {
    name                = "application-gateway-pip"
    resource_group_name = "rg-prepod"
    location            = "Central India"
  }
}

vms = {
  vm1 = {
    nic_name                        = "front-end-nic"
    resource_group_name             = "rg-prepod"
    location                        = "Central India"
    vm_name                         = "front-end-vm"
    vm_size                         = "Standard_D2s_v3"
    subnet_name                     = "frontend-subnet"
    pip_name                        = "front-end-pip"
    virtual_network_name            = "prepod-Vnet"
    ip_name                         = "frontend-ipconfig"
    private_ip_address_allocation   = "Dynamic"
    admin_username_secret_key       = "kv1-vm_admin_username"
    admin_password_secret_key       = "kv1-vm_admin_password"
    disable_password_authentication = false
    os_disk_caching                 = "ReadWrite"
    os_disk_storage_account_type    = "Standard_LRS"
    source_image_publisher          = "Canonical"
    source_image_offer              = "UbuntuServer"
    source_image_sku                = "16.04-LTS"
    source_image_version            = "latest"
  }

  vm2 = {
    nic_name                        = "backend-end-nic"
    resource_group_name             = "rg-prepod"
    location                        = "Central India"
    vm_name                         = "backend-end-vm"
    vm_size                         = "Standard_D2s_v3"
    subnet_name                     = "backend-subnet"
    pip_name                        = "back-end-pip"
    virtual_network_name            = "prepod-Vnet"
    ip_name                         = "backend-ipconfig"
    private_ip_address_allocation   = "Dynamic"
    admin_username_secret_key       = "kv1-vm_admin_username"
    admin_password_secret_key       = "kv1-vm_admin_password"
    disable_password_authentication = false
    os_disk_caching                 = "ReadWrite"
    os_disk_storage_account_type    = "Standard_LRS"
    source_image_publisher          = "Canonical"
    source_image_offer              = "UbuntuServer"
    source_image_sku                = "16.04-LTS"
    source_image_version            = "latest"
  }
}

application_gateway = {
  appgw1 = {
    name                           = "prepod-application-gateway"
    resource_group_name            = "rg-prepod"
    location                       = "Central India"
    subnet_name                    = "application-gateway-subnet"
    virtual_network_name           = "prepod-Vnet"
    public_ip_name                 = "application-gateway-pip"
    sku_name                       = "Standard_v2"
    sku_tier                       = "Standard_v2"
    sku_capacity                   = 2
    gateway_ip_configuration_name  = "appGatewayIpConfig"
    frontend_port_name             = "frontendPort"
    frontend_port                  = 80
    frontend_ip_configuration_name = "appGatewayFrontendIp"
    backend_address_pool_name      = "appGatewayBackendPool"
    backend_http_settings_name     = "appGatewayBackendHttpSettings"
    cookie_based_affinity          = "Disabled"
    backend_http_settings_port     = 80
    backend_http_settings_protocol = "Http"
    request_timeout                = 20
    http_listener_name             = "appGatewayHttpListener"
    http_listener_protocol         = "Http"
    request_routing_rule_name      = "appGatewayRoutingRule"
    rule_type                      = "Basic"
    priority                       = 100
  }
}
