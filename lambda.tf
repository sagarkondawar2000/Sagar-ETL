resource "aws_lambda_function" "s3_trigger_lambda" {
  filename         = "lambda_function.zip"
  function_name    = "s3-to-glue-trigger"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("lambda_function.zip")
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_trigger_lambda.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.etl_bucket.arn
}
