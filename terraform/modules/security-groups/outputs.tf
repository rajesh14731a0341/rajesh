output "efs_mount_sg_id" {
  value = aws_security_group.efs_mount.id
}

output "ecs_tasks_sg_id" {
  value = aws_security_group.ecs_tasks.id
}
