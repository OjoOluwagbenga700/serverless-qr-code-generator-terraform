# This file contains the configuration for the AWS Lambda function that will be triggered by the S3 bucket events.
resource "aws_lambda_function" "qr_code_lambda_function" {
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.qr_code_repo.repository_url}:latest"
  function_name = var.function_name
  role          = aws_iam_role.qr_code_lambda_role.arn
  timeout       = 30
  memory_size   = 1024


  environment {
    variables = {

      BUCKET_NAME = aws_s3_bucket.qr_code_bucket.bucket

    }
  }
  depends_on = [docker_registry_image.image, aws_iam_role.qr_code_lambda_role, aws_s3_bucket.qr_code_bucket]

}


resource "aws_lambda_function_url" "lambda_url" {
  function_name      = aws_lambda_function.qr_code_lambda_function.function_name
  authorization_type = "NONE"

  depends_on = [aws_lambda_function.qr_code_lambda_function]
}

