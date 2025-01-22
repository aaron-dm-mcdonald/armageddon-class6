
module "tokyo_network" {
  source = "./modules/network"

  region               = var.tokyo_config.region
  name                 = var.tokyo_config.name
  vpc_cidr             = var.tokyo_config.vpc_cidr
  public_subnet_cidr   = var.tokyo_config.public_subnet_cidr
  private_subnet_cidr  = var.tokyo_config.private_subnet_cidr
  database_subnet_cidr = var.tokyo_config.database_subnet_cidr
  num_public_subnets   = 2
  num_private_subnets  = 3
  num_database_subnets = 0
  tgw_id               = module.tgw_hq.tgw_id


}

module "tokyo_frontend" {
  source = "./modules/frontend"

  region            = var.tokyo_config.region
  name              = var.tokyo_config.name
  vpc_id            = module.tokyo_network.vpc_id
  public_subnet_ids = module.tokyo_network.public_subnet_ids
  target_group_arn  = module.tokyo_backend.target_group_arn
}

module "tokyo_backend" {
  source = "./modules/backend"

  region                = var.tokyo_config.region
  name                  = var.tokyo_config.name
  vpc_id                = module.tokyo_network.vpc_id
  private_subnet_ids    = module.tokyo_network.private_subnet_ids
  frontend_sg_id        = module.tokyo_frontend.frontend_sg_id
  backend_instance_type = var.backend_config.backend_instance_type[0]
  desired_capacity      = var.backend_config.desired_capacity
  scaling_range         = var.backend_config.scaling_range

  # Dynamically generate user_data with environment variables
  user_data = local.user_data
}


module "tgw_hq" {
  source = "./modules/tgw_hq"

  region             = var.tokyo_config.region
  vpc_id             = module.tokyo_network.vpc_id
  private_subnet_ids = module.tokyo_network.private_subnet_ids
}

module "bastion" {
  source = "./modules/bastion"
  providers = {
    aws = aws.tokyo
  }
  depends_on = [ module.tgw_hq, module.osaka_database ]

  region            = var.tokyo_config.region
  name              = var.tokyo_config.name
  vpc_id            = module.tokyo_network.vpc_id
  public_subnet_ids = module.tokyo_network.public_subnet_ids[0]

  # Use templatefile to dynamically generate the user_data script
  user_data = templatefile(
    "./scripts/app/bastion-host.sh.tpl",
    {
      db_host     = module.osaka_database.rw_endpoint,
      db_user     = var.db_user,        # Pass from variables
      db_password = var.db_password,  
      db_name     = "user_db"      
    }
  )
}

