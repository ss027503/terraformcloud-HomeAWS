data "aws_iam_policy_document" "ec2_role" {
    statement {
        sid     = "EC2Assume"
        effect  = "Allow"
        actions = ["sts:AssumeRole"]
        principals {
          type          = "Service"
          identifiers   = [ "ec2.amazonaws.com" ]
        }
    }
}

resource "aws_iam_role" "this" {
    name = "${local.project_name}-s3reader"
    assume_role_policy = data.aws_iam_policy_document.ec2_role.json
}

resource "aws_iam_role_policy_attachment" "this" {
    role        = aws_iam_role.this.id
    policy_arn  = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "this" {
    name    = "${local.project_name}-instance-profile"
    role    = aws_iam_role.this.name
}