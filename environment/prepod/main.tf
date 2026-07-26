module "resource_group" {
  source         = "../../modules/resource_group"
  resource_group = var.rgs
}

module "virtual_network" {
  depends_on      = [module.resource_group]
  source          = "../../modules/virtualNetwork"
  virtual_network = var.vNet
}

module "key_vault" {
  depends_on = [module.resource_group]
  source     = "../../modules/key_vault"
  key_vault  = var.key_vault
}

module "subnet" {
  depends_on = [module.virtual_network]
  source     = "../../modules/SubNet"
  subnet     = var.subnets
}

module "public_ip" {
  depends_on = [module.subnet]
  source     = "../../modules/public_ip"
  pip        = var.pip
}

module "virtual_machine" {
  depends_on = [module.public_ip, module.key_vault]
  source     = "../../modules/azurerm_virtual_machine"
  vms = {
    for vm_key, vm in var.vms : vm_key => merge(vm, {
      admin_username = module.key_vault.secret_values[vm.admin_username_secret_key]
      admin_password = module.key_vault.secret_values[vm.admin_password_secret_key]
    })
  }
}

module "application_gateway" {
  depends_on          = [module.public_ip]
  source              = "../../modules/application_gateway"
  application_gateway = var.application_gateway
}
