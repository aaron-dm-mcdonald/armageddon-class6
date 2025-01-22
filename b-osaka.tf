module "osaka_network" {
  source = "./modules/network"


  region               = var.osaka_config.region
  name                 = var.osaka_config.name
  vpc_cidr             = var.osaka_config.vpc_cidr
  public_subnet_cidr   = var.osaka_config.public_subnet_cidr
  private_subnet_cidr  = var.osaka_config.private_subnet_cidr
  database_subnet_cidr = var.osaka_config.database_subnet_cidr
  tgw_id               = module.osaka_tgw_branch.tgw_id
  num_public_subnets   = 1
  num_private_subnets  = 3
  num_database_subnets = 2

}

module "osaka_tgw_branch" {
  source = "./modules/tgw_branch"

  providers = {
    aws.default = aws.osaka
    aws.tokyo   = aws.tokyo
  }

  region              = var.osaka_config.region
  name                = var.osaka_config.name
  vpc_id              = module.osaka_network.vpc_id
  private_subnet_ids  = module.osaka_network.private_subnet_ids
  peer_tgw_id         = module.tgw_hq.tgw_id
  vpc_cidr            = var.osaka_config.vpc_cidr
  enable_return_route = true
}

module "osaka_database" {
  source = "./modules/database"

  region          = var.osaka_config.region
  vpc_id          = module.osaka_network.vpc_id
  name            = var.osaka_config.name
  db_subnet_group = module.osaka_network.db_subnet_group
  instance_count  = 1
  instance_class  = "db.t3.medium"
  db_user         = var.db_user
  db_password     = var.db_password
}

/* module "rds_cluster_aurora_mysql" {
  source = "cloudposse/rds-cluster/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"
  
  engine          = "aurora-mysql"
  cluster_family  = "aurora-mysql8.0"
  cluster_size    = 2
  name            = "db"
  admin_user      = "admin1"
  admin_password  = "Test123456789"
  db_name         = "dbname"
  instance_type   = "db.t3.medium"
  vpc_id          = module.tokyo_network.vpc_id
  security_groups = [module.tokyo_database.db_sg]
  subnets         = module.tokyo_network.db_subnet_ids
 
  providers = {
    aws = aws.tokyo
  }

} */



