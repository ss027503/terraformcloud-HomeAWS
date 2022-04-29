terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
      name = "aws-gaming"
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


## Data sources
data "aws_subnet" "this" {
    vpc_id  = var.vpc_id
    filter {
        name    = "availabilityZone"
        values  = ["us-east-2a"]
    }
}

data "aws_ami" "win2019" {
    most_recent         = true
    filter {
        name            = "name"
        values          = ["Windows_Server-2019-English-Full-Base-*"]
    }
    filter {
        name            = "virtualization-type"
        values          = ["hvm"]
    }
    owners              = ["amazon"]
}