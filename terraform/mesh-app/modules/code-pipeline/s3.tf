resource "aws_s3_bucket" "codepipeline" {
  bucket_prefix = "${var.artifact_bucket_prefix}"
  //acl           = "private"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "codepipeline" {
  bucket = aws_s3_bucket.codepipeline.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codepipeline" {
  depends_on = [aws_s3_bucket_ownership_controls.codepipeline]

  bucket = aws_s3_bucket.codepipeline.id
  acl    = "private"
}