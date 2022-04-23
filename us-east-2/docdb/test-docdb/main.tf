terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
      tags = ["us-east-2", "docdb"]
    }
  }
}

provider "aws" {
    region                  = var.aws_region
    assume_role {
      role_arn = "arn:aws:iam::639911800546:role/terraform-cloud-role"
    }

    default_tags {
        tags = {
            region = "${var.aws_region}"
            project = "${local.project_name}"
        }
    }
}

data "aws_subnets" "this" {
  filter {
    name   = "vpc-id"
    values = [local.vpc_id]
  }
}