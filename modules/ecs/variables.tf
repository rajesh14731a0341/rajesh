variable "environment" {
  type = string
}

variable "container_image" {
  type = string
}

variable "cpu" {
  type    = number
  default = 512
}

variable "memory" {
  type    = number
  default = 1024
}

variable "admin_password" {
  type = string
  sensitive = true
}

variable "efs_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}
