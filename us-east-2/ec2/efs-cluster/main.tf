provider "aws" {
    region                  = var.aws_region
}

terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
      Name = "efs-cluster"
      tags = ["us-east-2", "ec2", "efs"]
    }
  }
}

## DATA SOURCES
data "aws_subnet" "aza" {
    vpc_id  = local.vpc_id
    filter {
        name    = "availabilityZone"
        values  = ["us-east-1a"]
    }
}

data "aws_subnet" "azb" {
    vpc_id  = local.vpc_id
    filter {
        name    = "availabilityZone"
        values  = ["us-east-1b"]
    }
}

data "aws_ami" "win2019" {
    most_recent         = true
    filter {
        name            = "name"
        values          = ["Windows_Server-2016-English-Full-Base-*"]
    }
    filter {
        name            = "virtualization-type"
        values          = ["hvm"]
    }
    owners              = ["amazon"]
}