/* For creating vpc, sg, subnets, route and route table */
module "Networking" {
  source               = "./modules/Networking"
  vpc_cidr             = local.vpc_cidr
  public_subnets_cidr  = local.public_subnet_cidr
  private_subnets_cidr = local.private_subnet_cidr
  availability_zones   = local.availability_zones
}

/* For storage like s3 */
module "Storage" {
    source = "./modules/Storage"
    bucket_name = local.bucket_name
}

/* Creating security group, alb, and ecs cluster with service */
module "Compute" {
  source            = "./modules/Compute"
  ecs_cluster_name  = local.ecs_cluster_name
  vpc_id            = module.Networking.vpc_id
  private_subnet_id = module.Networking.private_subnet_id
  image_mutability  = "MUTABLE"
  ecr_name          = "${terraform.workspace}-${local.project_name}"
  project_name      = local.project_name
  service_name      = local.ecs_service_name
  public_subnet_id = module.Networking.public_subnet_id  
  /* container_port */
  /* desired_count */
}

/* Create a codepipeline with codecommit, codebuild, codedeploy */
module "Codepipeline" {
  source = "./modules/Codepipeline"
  environment_compute_type = local.codebuild_compute_type
  environment_image =  local.code_build_image
  environment_type = local.codebuild_env_type
  s3_id = module.Storage.S3-id
  ecs_tg = [module.Compute.ecs_tg_blue,module.Compute.ecs_tg_green]
  vpc_id = module.Networking.vpc_id
  public_subnets = module.Networking.public_subnet_id
  security_group = module.Compute.security_group_id
  ecs_cluster_name =local.ecs_cluster_name
  ecs_alb_listener = module.Compute.ecs_alb_listener
  service_name = "nginx-service"
  project_name = local.project_name
  env_vars = local.codebuild_env
} 

/* cloudfront attached to load balancer */
module "Cloudfront" {
  count = terraform.workspace == "prod" ? 1 : 0
  source = "./modules/Cloudfront"
  alb_dns_name = module.Compute.alb_dns_name
  price_class = local.price_class
  origin_protocol_policy = local.origin_protocol_policy
  caching_policy = local.caching_policy_for_cf
  /* viewer_protocol_policy */
  /* origin_request_policy */
  web_acl_arn= module.WebApplicationFirewall.waf_acl_arn
}

/* Create a SES service */
module "SES" {
  source = "./modules/SES"
}

/* Create Aurora database */
module "Database" {
  source = "./modules/Database"
  mysql_identifier = "${terraform.workspace}-db-cluster"
  username = var.sql_username
  password = var.sql_password
  database_name = local.database_name 
  project_name = local.project_name
  private_subnet_ids = module.Networking.private_subnet_id
  vpc_id = module.Networking.vpc_id
  vpc_cidr = local.vpc_cidr
} 

/* Create web acl to attach to cloudfront */ 
module "WebApplicationFirewall" {
  source = "./modules/WebApplicationFirewall"
}