provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  environment          = var.environment
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}

module "iam" {
  source      = "../../modules/iam"
  environment = var.environment
}

module "efs" {
  source      = "../../modules/efs"
  environment = var.environment
  subnet_ids  = module.network.public_subnet_ids
  efs_sg_id   = module.network.ecs_security_group_id
}

module "ecs" {
  source                     = "../../modules/ecs"
  environment                = var.environment
  container_image            = var.container_image
  cpu                        = 512
  memory                     = 1024
  admin_password             = var.admin_password
  efs_id                     = module.efs.efs_id
  subnet_ids                 = module.network.public_subnet_ids
  ecs_sg_id                  = module.network.ecs_security_group_id
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}
