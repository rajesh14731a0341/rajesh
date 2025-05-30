resource "aws_security_group" "efs_mount" {
  name        = "${var.name_prefix}-efs-sg"
  description = "Security group for EFS mount target"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-efs-sg"
  }
}

resource "aws_security_group" "ecs_tasks" {
  name        = "${var.name_prefix}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-ecs-sg"
  }
}

# Allow ECS tasks to connect to EFS
resource "aws_security_group_rule" "efs_allow_from_ecs" {
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  security_group_id        = aws_security_group.efs_mount.id
  source_security_group_id = aws_security_group.ecs_tasks.id
  description              = "Allow ECS tasks to access EFS"
}

# Optional: Egress rule from ECS tasks to EFS (if your ECS security group blocks outbound by default)
resource "aws_security_group_rule" "ecs_allow_efs_outbound" {
  type                          = "egress"
  from_port                     = 2049
  to_port                       = 2049
  protocol                      = "tcp"
  security_group_id             = aws_security_group.ecs_tasks.id
  destination_security_group_id = aws_security_group.efs_mount.id
  description                   = "Allow ECS tasks to send traffic to EFS"
}
