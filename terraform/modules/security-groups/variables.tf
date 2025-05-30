variable "vpc_id" {
  description = "The VPC ID where SGs will be created"
  type        = string
}

variable "name_prefix" {
  description = "Prefix to apply to SG names"
  type        = string
}
