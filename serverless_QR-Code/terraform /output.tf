
output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.qr_code_lambda_function.function_name
}

output "lambda_function_url" {
  description = "URL of the Lambda function"
  value       = aws_lambda_function_url.lambda_url.function_url
}

output "s3_bucket_url" {
  description = "URL of the S3 bucket for QR codes"
  value       = "https://${aws_s3_bucket.qr_code_bucket.bucket}.s3.amazonaws.com"
}