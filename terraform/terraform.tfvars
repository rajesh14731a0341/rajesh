project_name = "grafana"
vpc_cidr     = "10.0.0.0/16"
public_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

task_cpu      = 512
task_memory   = 1024
desired_count = 1

grafana_image  = "grafana/grafana-enterprise:11.6.1"
renderer_image = "grafana/grafana-image-renderer:latest"
redis_image    = "redis:latest"
