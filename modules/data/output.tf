output "s3_read_access_policy" {
  value = "${aws_iam_policy.s3_read_access.arn}"
}