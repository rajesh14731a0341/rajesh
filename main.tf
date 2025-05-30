# project-root/main.tf

# Main Terraform configuration file.
# It defines the AWS provider and orchestrates calls to all other modules.

# Define the AWS provider
provider "aws" {
  region = var.aws_region # Uses the AWS region defined in variables.tf
}

# ----------------------------------------------------
# Module Calls - Orchestrates the deployment of various infrastructure components
# ----------------------------------------------------

# Network Module: Creates VPC, subnets, internet gateway, and route tables.
module "network" {
  source = "./modules/network" # Path to the network module

  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
}

# IAM Module: Creates necessary IAM roles for ECS task execution and service.
module "iam" {
  source = "./modules/iam" # Path to the IAM module

  project_name = var.project_name
  environment  = var.environment
}

# Security Module: Defines all required security groups for ALB, ECS tasks, and EFS.
module "security" {
  source = "./modules/security" # Path to the security module

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.network.vpc_id # Depends on network module for VPC ID
  grafana_container_port    = var.grafana_container_port
  redis_container_port      = var.redis_container_port
  grafana_renderer_port     = var.grafana_renderer_port
}

# ALB Module: Creates the Application Load Balancer, target group, and listener for Grafana.
module "alb" {
  source = "./modules/alb" # Path to the ALB module

  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.network.vpc_id # Depends on network module for VPC ID
  public_subnet_ids         = module.network.public_subnet_ids # Depends on network module for public subnets
  alb_security_group_id     = module.security.alb_security_group_id # Depends on security module for ALB SG ID
  grafana_container_port    = var.grafana_container_port
  # acm_certificate_arn       = var.acm_certificate_arn # Uncomment if using HTTPS and provide ARN
}

# ECS Module: Sets up the ECS Cluster, EFS file systems, Task Definition (Grafana, Renderer, Redis), and ECS Service.
module "ecs" {
  source = "./modules/ecs" # Path to the ECS module

  project_name                 = var.project_name
  environment                  = var.environment
  aws_region                   = var.aws_region
  public_subnet_ids            = module.network.public_subnet_ids # Depends on network module for public subnets
  ecs_task_execution_role_arn  = module.iam.ecs_task_execution_role_arn # Depends on IAM module for execution role ARN
  ecs_service_role_arn         = module.iam.ecs_service_role_arn # Depends on IAM module for service role ARN
  ecs_task_security_group_id   = module.security.ecs_task_security_group_id # Depends on security module for ECS Task SG ID
  efs_security_group_id        = module.security.efs_security_group_id # Depends on security module for EFS SG ID

  grafana_image_version        = var.grafana_image_version
  grafana_renderer_image_version = var.grafana_renderer_image_version
  redis_image_version          = var.redis_image_version
  ecs_task_cpu                 = var.ecs_task_cpu
  ecs_task_memory              = var.ecs_task_memory
  desired_task_count           = var.desired_task_count
  alb_target_group_arn         = module.alb.alb_target_group_arn # Depends on ALB module for target group ARN
  grafana_container_port       = var.grafana_container_port
  redis_container_port         = var.redis_container_port
  grafana_renderer_port        = var.grafana_renderer_port
}