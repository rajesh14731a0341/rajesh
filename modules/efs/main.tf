resource "aws_efs_file_system" "this" {
  creation_token = "${var.environment}-efs"
  tags = {
    Name = "${var.environment}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = element(var.subnet_ids, count.index)
  security_groups = [var.efs_sg_id]
}
