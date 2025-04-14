# S3 Bucket for storing QR codes
resource "aws_s3_bucket" "qr_code_bucket" {
  bucket        = var.bucket_name
  force_destroy = true
}

# S3 Bucket Public Access Block
resource "aws_s3_bucket_public_access_block" "qr_code_bucket_public_access" {
  bucket = aws_s3_bucket.qr_code_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



# QR Code bucket policy
resource "aws_s3_bucket_policy" "qr_code_bucket_policy" {
  bucket = aws_s3_bucket.qr_code_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadWrite"
        Effect    = "Allow"
        Principal = "*"
        Action    = ["s3:GetObject", "s3:PutObject"]
        Resource  = ["${aws_s3_bucket.qr_code_bucket.arn}/*"]
      }
    ]
  })
}

