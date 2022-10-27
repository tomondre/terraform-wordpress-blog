resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "pubic_key" {
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "asg_security_group" {
  ingress {
    from_port = 443
    protocol  = "TCP"
    to_port   = 443
    security_groups = aws_alb.alb.security_groups
  }
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

  resource "aws_alb_target_group" "asg_tg" {
name = "blog-tf"
    port = 443
    vpc_id = var.vpc_id
    protocol = "HTTPS"
}

module "autoscaling_group" {
  source          = "terraform-aws-modules/autoscaling/aws"
  image_id        = var.ami_id
  key_name        = aws_key_pair.pubic_key.key_name
  security_groups = [aws_security_group.asg_security_group.id]
  name            = "${local.name_prefix}-asg"
  min_size        = var.min_size
  max_size        = var.max_size
  vpc_zone_identifier = var.private_subnet_ids
  instance_type = "t2.micro"
  target_group_arns = [aws_alb_target_group.asg_tg.arn]
  create_iam_instance_profile = true
  iam_role_name = "blog-instance-role"
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}
