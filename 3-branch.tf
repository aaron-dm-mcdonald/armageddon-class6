# # Network Module
# module "branch_network" {
#   for_each = local.branch_offices

#   source = "./modules/network"

#   region              = each.value.region
#   name                = each.value.name
#   vpc_cidr            = each.value.vpc_cidr
#   public_subnet_cidr  = each.value.public_subnet_cidr
#   private_subnet_cidr = each.value.private_subnet_cidr
#   tgw_id              = module.tgw_hq.tgw_id
#   num_public_subnets = 2
#   num_private_subnets = 2
#   num_database_subnets = 2
# }

# # Frontend Module
# module "branch_frontend" {
#   for_each = local.branch_offices

#   source = "./modules/frontend"

#   region            = each.value.region
#   name              = each.value.name
#   vpc_id            = module.branch_network[each.key].vpc_id
#   public_subnet_ids = module.branch_network[each.key].public_subnet_ids
#   target_group_arn  = module.branch_backend[each.key].target_group_arn
# }

# # Backend Module
# module "branch_backend" {
#   for_each = local.branch_offices

#   source = "./modules/backend"

#   region                = each.value.region
#   name                  = each.value.name
#   vpc_id                = module.branch_network[each.key].vpc_id
#   private_subnet_ids    = module.branch_network[each.key].private_subnet_ids
#   frontend_sg_id        = module.branch_frontend[each.key].frontend_sg_id
#   backend_instance_type = var.backend_config.backend_instance_type[0]
#   desired_capacity      = var.backend_config.desired_capacity
#   scaling_range         = var.backend_config.scaling_range
#   user_data             = var.backend_config.user_data
# }

# # TGW Branch Module
# module "branch_tgw_branch" {
#   for_each = local.branch_offices

#   source = "./modules/tgw_branch"

#   providers = {
#     aws.default = aws[each.key]
#     aws.tokyo   = aws.tokyo
#   }

#   region             = each.value.region
#   name               = each.value.name
#   vpc_id             = module.branch_network[each.key].vpc_id
#   private_subnet_ids = module.branch_network[each.key].private_subnet_ids
#   peer_tgw_id        = module.tgw_hq.tgw_id
#   vpc_cidr           = each.value.vpc_cidr
# }
