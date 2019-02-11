# S3 bucket
resource "aws_s3_bucket" "website_content" {
  bucket = "${var.bucket_name}"
  acl    = "private"

  tags = {
    Name        = "Website bucket"
  }
}

# policy document to allow read only access
data "aws_iam_policy_document" "s3_read_access" {
  statement {
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation",
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.website_content.arn}",
      "${format("%s/*",aws_s3_bucket.website_content.arn)}",
    ]
  }
}

# policy to allow read only access
resource "aws_iam_policy" "s3_read_access" {
  name   = "s3_read_access"
  path   = "/"
  policy = "${data.aws_iam_policy_document.s3_read_access.json}"
}