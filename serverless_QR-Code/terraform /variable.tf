variable "region" {
  type        = string
  description = "Region of deployment"
  default = "us-east-1"
}

variable "repository_name" {
  type        = string
  description = "Elastic Container Resgistry Name"
  default     = "qr-code-repo"
}

variable "bucket_name" {
  type        = string
  description = "Bucket to store QR code"
  default     = "qr-code-bucket-007"
}

variable "function_name" {
  type        = string
  description = "lambda function name "
  default     = "qr-code-function"

}
variable "frontend_bucket_name" {
  type        = string
  description = "S3 bucket name for frontend hosting"
  default     = "qr-code-frontend-bucket-007"
}