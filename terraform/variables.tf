variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project_name" {
  type    = string
  default = "grafana"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "task_cpu" {
  type    = number
  default = 512
}

variable "task_memory" {
  type    = number
  default = 1024
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "grafana_image" {
  type    = string
  default = "grafana/grafana-enterprise:11.6.1"
}

variable "renderer_image" {
  type    = string
  default = "grafana/grafana-image-renderer:latest"
}

variable "redis_image" {
  type    = string
  default = "redis:latest"
}
