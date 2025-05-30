output "ecs_cluster_name" {
  value = module.ecs_cluster.cluster_name
}

output "ecs_service_name" {
  value = module.ecs_task_service.service_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "efs_filesystem_id" {
  value = module.efs.efs_id
}

output "grafana_public_dns" {
  description = "Public DNS to access Grafana"
  value       = aws_lb.grafana_lb.dns_name
}
