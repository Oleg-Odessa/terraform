provider "aws" {
  region = "eu-north-1"
}

#To delete all data, before destroy, run on Linux with AWS CLI:
# aws s3 rm s3://oleg-drachyshyn-terraform-state --recursive
resource "aws_s3_bucket" "bucket_for_remote_state" {
  bucket = "oleg-drachyshyn-terraform-state"
  acl    = "private"

  tags = {
    Name        = "oleg-drachyshyn-terraform-state"
    Environment = "ADV-IT"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_for_remote_state" {
  bucket = aws_s3_bucket.bucket_for_remote_state.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
