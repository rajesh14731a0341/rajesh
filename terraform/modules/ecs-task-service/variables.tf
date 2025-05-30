variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "cluster_name" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "grafana_image" {
  type = string
}

variable "renderer_image" {
  type = string
}

variable "redis_image" {
  type = string
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "ecs_tasks_sg_id" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "efs_access_point_id" {
  type = string
}
