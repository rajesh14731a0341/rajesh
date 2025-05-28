variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "container_image" {
  type = string
}

variable "admin_password" {
  type      = string
  sensitive = true
}
