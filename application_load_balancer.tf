resource "aws_security_group" "alb_security_group" {
  name = "alb-sg"
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb" {
  name               = "blog-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups = [aws_security_group.alb_security_group.id]
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_acm_certificate" "host_certificate" {
  private_key       = file("${path.module}/private.pem")
  certificate_body  = file("${path.module}/certificate_body.cer")
  certificate_chain = file("${path.module}/chain.pem")
}

resource "aws_lb_listener" "https_forward" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate.host_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.asg_tg.arn
  }
}