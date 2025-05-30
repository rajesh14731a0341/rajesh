resource "aws_efs_file_system" "this" {
  tags = {
    Name = "${var.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "this" {
  count          = length(var.subnet_ids)
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = var.subnet_ids[count.index]
  security_groups = [var.efs_mount_sg_id]
}
