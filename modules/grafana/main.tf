resource "aws_ecs_cluster" "this" {
  name = "${var.env}-ecs-cluster"
}

resource "aws_security_group" "grafana_sg" {
  name        = "${var.env}-grafana-sg"
  description = "Security group for Grafana"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow HTTP from ALB"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    security_groups  = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-grafana-sg"
  }
}

resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "${var.env}-alb"
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.env}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  
  # THIS LINE IS REQUIRED FOR awsvpc NETWORK MODE
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-399"
  }
  tags = {
    Name = "${var.env}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.env}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "grafana" {
  family                   = "${var.env}-grafana-task"
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([{
    name      = "grafana"
    image     = var.docker_image
    essential = true
    portMappings = [{
      containerPort = 3000
      protocol      = "tcp"
    }]
    environment = [
      {
        name  = "GF_SECURITY_ADMIN_PASSWORD"
        value = var.admin_password
      }
    ]
  }])
}

resource "aws_ecs_service" "grafana" {
  name            = "${var.env}-grafana-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.grafana.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.grafana_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "grafana"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}
