provider "aws" {
    region                  = var.aws_region
    profile                 = "CaptDanger"
}

terraform {
  cloud {
    organization = "ss027n4-home"

    workspaces {
      Name = 
      tags = ["us-east-2", "ec2"]
    }
  }
}