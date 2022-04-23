locals {
  vpc_id              = "vpc-87d13fee"
  project_name = "efs-cluster"
  
  instance_type       = "t3.micro"
  instance_disk_size  = 10
  instance_key        = "home-use2"
}

resource "aws_placement_group" "this" {
  name     = "${local.project_name}-placement-group"
  strategy = "spread"
}

module "test_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "${local.project_name}-cluster"
  instance_count         = 2
  placement_group        = aws_placement_group.this.id

  ami                    = data.aws_ami.ubuntu_latest.id
  instance_type          = local.instance_type
  key_name               = local.instance_key
  monitoring             = false
  vpc_security_group_ids = [module.instance_security_group.security_group_id]
  subnet_ids             = [data.aws_subnet.aza.id, data.aws_subnet.azb.id]

  user_data = <<-EOF
		#! /bin/bash
    sudo apt-get update
		sudo apt-get install -y apache2
    echo "<h1>Deployed via Terraform, cool</h1>" | sudo tee /var/www/html/index.html
		sudo systemctl enable apache2
		sudo systemctl start apache2
    sudo apt install nfs-common -y
    sudo mkdir /mnt/efs
    sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.this.dns_name}:/  /mnt/efs
	  EOF

  root_block_device = [
      {
          volume_size = local.instance_disk_size
          volume_type = "gp3"
      }
  ]
}

module "instance_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version                = "~> 4.0"

  name        = "${local.project_name}-sg"
  description = "Security group for ${local.project_name}"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
        {
        rule        = "ssh-tcp"
        description = "SSH to bastion"
        cidr_blocks = "108.247.248.22/32"
        },
        {
        rule        = "http-80-tcp"
        description = "HTTP"
        cidr_blocks = "0.0.0.0/0"
        }
    ]
  egress_with_cidr_blocks = [
        {
        rule        = "all-all"
        cidr_blocks = "0.0.0.0/0"
        }  
    ]   
}