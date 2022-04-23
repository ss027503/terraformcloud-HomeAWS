terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
      tags = ["us-east-2", "ec2", "efs"]
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

## DATA SOURCES
data "aws_subnet" "aza" {
    vpc_id  = local.vpc_id
    filter {
        name    = "availabilityZone"
        values  = ["${var.aws_region}a"]
    }
}

data "aws_subnet" "azb" {
    vpc_id  = local.vpc_id
    filter {
        name    = "availabilityZone"
        values  = ["${var.aws_region}b"]
    }
}

# Get latest Ubuntu 18.04 AMI for bastion host
data "aws_ami" "ubuntu_latest" {
    most_recent         = true
    filter {
        name            = "name"
        values          = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }
    filter {
        name            = "virtualization-type"
        values          = ["hvm"]
    }
    owners              = ["099720109477"]
}