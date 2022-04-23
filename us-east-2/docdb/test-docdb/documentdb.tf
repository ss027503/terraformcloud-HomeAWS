locals {
    vpc_id              = "vpc-87d13fee"
    project_name = "test-docdb-cluster"
}

resource "aws_docdb_subnet_group" "default" {
  name       = "${local.project_name}-subnet-group"
  subnet_ids = data.aws_subnets.this.ids

  tags = {
    Name = "${local.project_name}-subnet-group"
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier      = "test-docdb-cluster"
  engine                  = "docdb"
  engine_version          = "4.0"
  availability_zones      = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  vpc_security_group_ids = [module.docdb_security_group.security_group_id]

  master_username         = "docdbadmin"
  master_password         = aws_secretsmanager_secret_version.password.secret_string

  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"

  skip_final_snapshot     = true
  deletion_protection = false
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = 3
  identifier         = "${local.project_name}-${count.index}"
  cluster_identifier = aws_docdb_cluster.this.id
  instance_class     = "db.t4g.medium"
}

resource "aws_docdb_cluster_parameter_group" "this" {
  family      = "docdb4.0"
  name        = "no-tls"
  description = "docdb cluster parameter group"

  parameter {
    name  = "tls"
    value = "disabled"
  }
}

module "docdb_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.project_name}"
  description = "Security group for ${local.project_name}"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
        {
        from_port   = 27017
        to_port     = 27017
        protocol    = "tcp"
        description = "MongoDB port for VPC"
        cidr_blocks = "172.31.0.0/16"
        }
    ]

  egress_with_cidr_blocks = [
        {
        rule        = "all-all"
        cidr_blocks = "0.0.0.0/0"
        }  
    ]   
}