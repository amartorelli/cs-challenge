# security group to allow web traffic to the instances (both HTTP/HTTPS even if we only use HTTP)
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow inbound HTTP/HTTPS traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.web-loadbalancer.id}"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.web-loadbalancer.id}"]
  }
}

# generic security group to allow SSH and outbound traffic
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow inbound SSH traffic"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = "${var.sg_ssh_cidr}"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}