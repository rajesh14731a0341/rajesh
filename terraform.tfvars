# project-root/terraform.tfvars

# Default variable values for your Terraform configuration.
# These values will be used unless explicitly overridden (e.g., via CLI or CI/CD).

project_name                 = "rajeshso" # All resources will be prefixed with this name
environment                  = "dev"      # Current deployment environment
aws_region                   = "us-east-1" # The AWS region where resources will be deployed

# Network configuration
vpc_cidr_block               = "10.0.0.0/16" # CIDR block for the VPC
public_subnet_cidrs          = ["10.0.1.0/24", "10.0.2.0/24"] # CIDR blocks for public subnets

# Docker Image Versions (pulled from Docker Hub)
grafana_image_version        = "11.1.0-ubuntu"      # Specific version for Grafana Enterprise
grafana_renderer_image_version = "latest"          # Using latest for Grafana Image Renderer
redis_image_version          = "latest"             # Using latest for Redis

# Container Port Mappings
grafana_container_port       = 3000 # Default port for Grafana
grafana_renderer_port        = 8081 # Default port for Grafana Image Renderer
redis_container_port         = 6379 # Default port for Redis

# ECS Task and Service Configuration
ecs_task_cpu                 = 1024 # 1 vCPU for the combined ECS task (Grafana, Renderer, Redis)
ecs_task_memory              = 2048 # 2 GB memory for the combined ECS task
desired_task_count           = 1    # Number of desired running instances of the Grafana service