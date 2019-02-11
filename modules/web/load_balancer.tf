# load balancer
resource "aws_lb" "web" {
  name               = "web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.web-loadbalancer.id}"]
  subnets            = ["${var.public_subnets}"]

  enable_deletion_protection = true
}

# target group used by the load balancer
resource "aws_lb_target_group" "web" {
  name     = "web"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
}

# listener for the load balancer (port 80)
resource "aws_lb_listener" "web" {
  load_balancer_arn = "${aws_lb.web.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.web.arn}"
  }
}

# security group for the load balancer to allow HTTP/HTTPS traffic (even though we serve only HTTP here)
resource "aws_security_group" "web-loadbalancer" {
  name        = "web-loadbalancer"
  description = "Allow inbound HTTP/HTTPS traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}