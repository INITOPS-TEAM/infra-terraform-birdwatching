# S3 module

## Purpose
Creates an S3 bucket managed by Terraform.

## Resources
- aws_s3_bucket

## Inputs
- bucket_name - name of the S3 bucket

## Outputs
- bucket_name
- bucket_arn

## Notes
- This module does not manage bucket policies or lifecycle rules.
