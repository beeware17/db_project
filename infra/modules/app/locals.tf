locals {
  short_env_map = {
    development = "dev"
    production  = "prod"
  }
  short_region_map = {
    eu-central-1 = "euc1"
  }

  short_region         = lookup(local.short_region_map, var.aws_region)
  short_env            = lookup(local.short_env_map, var.environment)
  resource_name_suffix = "%s-${local.short_region}-${local.short_env}"

  common_tags = {
    environment          = var.environment
    managed_by_terraform = "true"
  }

  app_subnet_id = var.private_subnets_ids[0]
}

