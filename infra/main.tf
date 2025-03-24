#TODO: Invoke modules. Explain workspaces
module "network" {
  source                 = "./modules/network"
  aws_region             = var.aws_region
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnets_config  = var.public_subnets_config
  private_subnets_config = var.private_subnets_config
}

module "app" {
  source              = "./modules/app"
  aws_region          = var.aws_region
  environment         = var.environment
  vpc_id              = module.network.vpc_id
  private_subnets_ids = module.network.private_subnets_ids
  app_image           = var.app_image

}