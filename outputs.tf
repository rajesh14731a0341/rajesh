# project-root/outputs.tf

# Defines output values that can be easily retrieved after `terraform apply`.

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer for Grafana."
  value       = module.alb.alb_dns_name # Fetches output from the ALB module
}

output "ecs_cluster_name" {
  description = "The name of the created ECS Cluster."
  value       = module.ecs.ecs_cluster_name # Fetches output from the ECS module
}

output "ecs_service_name" {
  description = "The name of the created ECS Service."
  value       = module.ecs.ecs_service_name # Fetches output from the ECS module
}