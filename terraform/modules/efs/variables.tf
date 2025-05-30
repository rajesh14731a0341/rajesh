variable "project_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "efs_mount_sg_id" {
  type = string
}
