resource "aws_secretsmanager_secret" "this" {
  name = "home/my-docdb-test-secret"
}

resource "aws_secretsmanager_secret_version" "password" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = random_password.password.result
}

resource "random_password" "password" {
  length           = 18
  special          = false
}