module "instance_security_group" {
  source = "terraform-aws-modules/security-group/aws"
  version                = "~> 4.0"

  name        = "${local.project_name}-sg"
  description = "Security group for ${local.project_name}"
  vpc_id      = local.vpc_id

  ingress_with_cidr_blocks = [
        {
        rule        = "rdp-tcp"
        description = "RDP from home"
        cidr_blocks = "108.247.248.22/32"
        }
    ]
  egress_with_cidr_blocks = [
        {
        rule        = "all-all"
        cidr_blocks = "0.0.0.0/0"
        }  
    ]   
}