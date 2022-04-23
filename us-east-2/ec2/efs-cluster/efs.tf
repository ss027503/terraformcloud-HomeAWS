resource "aws_efs_file_system" "this" {
  creation_token    = "test-efs"
  encrypted         = true

  lifecycle_policy {
    transition_to_ia = "AFTER_60_DAYS"
  }
  
  tags = {
    Name = "${local.project_name}-efs"
  }
}

resource "aws_efs_mount_target" "aza" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = data.aws_subnet.aza.id
}

resource "aws_efs_mount_target" "azb" {
  file_system_id = aws_efs_file_system.this.id
  subnet_id      = data.aws_subnet.azb.id
}