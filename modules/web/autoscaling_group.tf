# script to run when the instance is bootstrapped
data "template_file" "userdata_webserver" {
    template = "${file("${path.module}/templates/userdata.sh")}"
}

# instance profile used to attach the role to the instance
resource "aws_iam_instance_profile" "webserver" {
  name = "webserver"
  role = "${aws_iam_role.webserver.name}"
}

# launch configuration to be used
resource "aws_launch_configuration" "webserver" {
    name = "webserver"
    image_id      = "${var.ami}"
    instance_type = "${var.instance_type}"
    security_groups = ["${aws_security_group.ssh.id}", "${aws_security_group.web.id}"]
    user_data = "${data.template_file.userdata_webserver.rendered}"
    key_name = "${var.key_name}"
    iam_instance_profile = "${aws_iam_instance_profile.webserver.name}"
}

# IAM role to attach to the instances
resource "aws_iam_role" "webserver" {
  name = "webserver"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# attach policy to the role so that the instances can read from S3
resource "aws_iam_role_policy_attachment" "s3_read_policy" {
  role       = "${aws_iam_role.webserver.name}"
  policy_arn = "${var.s3_read_access_policy}"
}

# autoscaling group
resource "aws_autoscaling_group" "webserver" {
  launch_configuration = "${aws_launch_configuration.webserver.name}"
  min_size = "${var.min_instances}"
  max_size = "${var.max_instances}"

  vpc_zone_identifier = ["${var.private_subnets}"]
  target_group_arns = ["${aws_lb_target_group.web.arn}"]

  lifecycle {
    create_before_destroy = true
  }
}