resource "aws_s3_bucket" "app_bucket" {
  bucket = var.bucket_name

  lifecycle {
    prevent_destroy = true
  }
}
