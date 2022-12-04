#resource "aws_vpc_peering_connection" "vpc-peering" {
#  peer_vpc_id = ""
#  vpc_id      = ""
#}
resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "is-website-exists"
  force_destroy = true
}
resource "aws_s3_object" "object_s3" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "lambda-mongodb/src"
  source = "../../src/index.js"
}
resource "aws_iam_role" "lambda_is_websites_exists_role" {
  name = "iam_for_lambda_main_app_tp2"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
data "archive_file" "main" {
  type        = "zip"
  source_dir  = "../../src"
  output_path = "${path.module}/.terraform/archive_files/function.zip"
}

resource "aws_lambda_function" "lambda_main_app_tp2" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  role             = aws_iam_role.lambda_is_websites_exists_role.arn
  filename         = "${path.module}/.terraform/archive_files/function.zip"
  handler          = "index.hello"
  runtime          = "nodejs18.x"
  function_name    = "is-websites-exists"
  source_code_hash = data.archive_file.main.output_base64sha256
}


