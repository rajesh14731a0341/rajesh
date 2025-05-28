resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-ecs-cluster"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.environment}-grafana-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "grafana"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = 3000
          protocol      = "tcp"
        }
      ]
      mountPoints = [
        {
          sourceVolume  = "grafana-storage"
          containerPath = "/var/lib/grafana"
          readOnly      = false
        }
      ]
      environment = [
        {
          name  = "GF_SECURITY_ADMIN_PASSWORD"
          value = var.admin_password
        }
      ]
    }
  ])

  volume {
    name = "grafana-storage"
    efs_volume_configuration {
      file_system_id     = var.efs_id
      root_directory     = "/grafana"
      transit_encryption = "ENABLED"
      authorization_config {
        access_point_id = null
        iam             = "DISABLED"
      }
    }
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.environment}-grafana-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = true
  }

  depends_on = [
    aws_ecs_task_definition.this
  ]
}
