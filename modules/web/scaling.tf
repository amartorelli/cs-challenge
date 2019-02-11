# policy to be used when scaling up
resource "aws_autoscaling_policy" "webserver-up" {
  name                   = "autoscaling-policy-webserver-up"
  scaling_adjustment     = "${var.alarm_scaling_adjustment}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.webserver.name}"
}

# scale up alarm
resource "aws_cloudwatch_metric_alarm" "webserver-up" {
  alarm_name          = "webserver-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.alarm_metric}"
  namespace           = "AWS/EC2"
  period              = "${var.alarm_period}"
  statistic           = "Average"
  threshold           = "${var.alarm_scale_up_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.webserver.name}"
  }

  alarm_description = "This metric monitors webservers ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.webserver-up.arn}"]
}

# policy when scaling down
resource "aws_autoscaling_policy" "webserver-down" {
  name                   = "autoscaling-policy-webserver-down"
  scaling_adjustment     = "-${var.alarm_scaling_adjustment}"
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = "${aws_autoscaling_group.webserver.name}"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "webserver-down" {
  alarm_name          = "webserver-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "${var.alarm_metric}"
  namespace           = "AWS/EC2"
  period              = "${var.alarm_period}"
  statistic           = "Average"
  threshold           = "${var.alarm_scale_down_threshold}"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.webserver.name}"
  }

  alarm_description = "This metric monitors webservers ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.webserver-down.arn}"]
}