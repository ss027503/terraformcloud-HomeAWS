provider "aws" {
    region                  = var.aws_region
}

terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
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