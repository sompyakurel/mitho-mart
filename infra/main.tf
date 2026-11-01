terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "mitho_mart" {
  bucket = "mitho-mart-portfolio-sompyakurel"
}

resource "aws_s3_bucket_website_configuration" "mitho_mart" {
  bucket = aws_s3_bucket.mitho_mart.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "mitho_mart" {
  bucket = aws_s3_bucket.mitho_mart.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "mitho_mart" {
  bucket = aws_s3_bucket.mitho_mart.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "arn:aws:s3:::${aws_s3_bucket.mitho_mart.id}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.mitho_mart]
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.mitho_mart.id
  key          = "index.html"
  source       = "../index.html"
  content_type = "text/html"
  etag         = filemd5("../index.html")
}

resource "aws_s3_object" "style" {
  bucket       = aws_s3_bucket.mitho_mart.id
  key          = "style.css"
  source       = "../style.css"
  content_type = "text/css"
  etag         = filemd5("../style.css")
}
output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.mitho_mart.website_endpoint
}

