variable "env" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}

variable "docker_image" {
  description = "Docker image for Grafana"
  type        = string
  default     = "grafana/grafana:latest"
}

variable "admin_password" {
  description = "Grafana admin password"
  type        = string
  sensitive   = true
}

