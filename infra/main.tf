#TODO: Invoke modules. Explain workspaces
module "network" {
  source                 = "./modules/network"
  aws_region             = var.aws_region
  environment            = var.environment
  vpc_cidr               = var.vpc_cidr
  public_subnets_config  = var.public_subnets_config
  private_subnets_config = var.private_subnets_config
}