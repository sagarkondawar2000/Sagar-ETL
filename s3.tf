resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.bucket_name

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.etl_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "input_folder" {
  bucket     = aws_s3_bucket.etl_bucket.id
  key        = "employee_data/input/"
  depends_on = [aws_s3_bucket.etl_bucket]
}

resource "aws_s3_object" "output_folder" {
  bucket     = aws_s3_bucket.etl_bucket.id
  key        = "employee_data/output/"
  depends_on = [aws_s3_bucket.etl_bucket]
}

resource "aws_s3_object" "script_upload" {
  bucket     = aws_s3_bucket.etl_bucket.id
  key        = "scripts/salary_filter_job.py"
  source     = "${path.module}/glue_job/salary_filter_job.py"
  etag       = filemd5("${path.module}/glue_job/salary_filter_job.py")
  depends_on = [aws_s3_bucket.etl_bucket]
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.etl_bucket.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_trigger_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "employee_data/input/"
  }
  depends_on = [aws_lambda_permission.allow_s3]
}