resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.environment}-ecs-task-execution-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "custom_grafana_policy" {
  name        = "${var.environment}-grafana-policy"
  description = "Custom policy for Grafana ECS task"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::your-grafana-config-bucket",
          "arn:aws:s3:::your-grafana-config-bucket/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = aws_iam_policy.custom_grafana_policy.arn
}
