# Define the trust relationship for lambda
data "aws_iam_policy_document" "qr_code_lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Create the lambda role
resource "aws_iam_role" "qr_code_lambda_role" {
  name               = "qr-code-lambda_role"
  assume_role_policy = data.aws_iam_policy_document.qr_code_lambda_trust.json
}

# Define the lambda policy document
data "aws_iam_policy_document" "qr_code_lambda_policy_doc" {
  statement {
    actions = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.function_name}:*"
    ]
  }
  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:CreateBucket", "s3:ListBucket"]
    effect  = "Allow"
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetAuthorizationToken"
    ]
    resources = [aws_ecr_repository.qr_code_repo.arn]
  }
}


# Create the lambda  policy
resource "aws_iam_policy" "lambda_s3_policy" {
  name   = "qr-code-lambda-policy"
  policy = data.aws_iam_policy_document.qr_code_lambda_policy_doc.json
}

# Attach the Lambda policy to the Lambda role 
resource "aws_iam_role_policy_attachment" "qr_code_lambda_policy_attach" {
  role       = aws_iam_role.qr_code_lambda_role.name
  policy_arn = aws_iam_policy.lambda_s3_policy.arn
}



