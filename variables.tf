# project-root/variables.tf

# Defines all input variables used across your Terraform configuration.

variable "project_name" {
  description = "A standard prefix for all resources created."
  type        = string
  default     = "rajeshso" # Default value, can be overridden
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev" # Default value, can be overridden
}

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1" # Default value, can be overridden
}

# Network Variables
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16" # Default VPC CIDR
}

variable "public_subnet_cidrs" {
  description = "A list of CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"] # Default public subnet CIDRs
}

# Application Image Versions (from Docker Hub)
variable "grafana_image_version" {
  description = "The version of the Grafana Enterprise Docker image from Docker Hub."
  type        = string
  default     = "11.1.0-ubuntu" # Default Grafana image version
}

variable "grafana_renderer_image_version" {
  description = "The version of the Grafana Image Renderer Docker image from Docker Hub."
  type        = string
  default     = "latest" # Default Grafana Renderer image version
}

variable "redis_image_version" {
  description = "The version of the Redis Docker image from Docker Hub."
  type        = string
  default     = "latest" # Default Redis image version
}

# Container Port Mappings
variable "grafana_container_port" {
  description = "The port Grafana listens on inside the container (e.g., 3000)."
  type        = number
  default     = 3000
}

variable "grafana_renderer_port" {
  description = "The port Grafana Image Renderer listens on inside the container (e.g., 8081)."
  type        = number
  default     = 8081
}

variable "redis_container_port" {
  description = "The port Redis listens on inside the container (e.g., 6379)."
  type        = number
  default     = 6379
}

# ECS Task & Service Variables
variable "ecs_task_cpu" {
  description = "CPU units for the ECS task (e.g., 1024 for 1 vCPU, 2048 for 2 vCPU)."
  type        = number
  default     = 1024 # Default CPU allocation for the task
}

variable "ecs_task_memory" {
  description = "Memory (in MiB) for the ECS task (e.g., 2048 MiB = 2 GB)."
  type        = number
  default     = 2048 # Default memory allocation for the task
}

variable "desired_task_count" {
  description = "The desired number of running tasks for the Grafana service."
  type        = number
  default     = 1 # Default desired task count
}