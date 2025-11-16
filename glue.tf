resource "aws_glue_job" "salary_filter_job" {
  name     = "salary-filter-job"
  role_arn = aws_iam_role.glue_role.arn
  command {
    name = "glueetl"
    python_version = "3"
    script_location = "s3://${var.bucket_name}/scripts/salary_filter_job.py"
  }
  default_arguments = {
    "--job-language" = "python"
    "--input_path"  = "s3://${var.bucket_name}/employee_data/input/"
    "--output_path" = "s3://${var.bucket_name}/employee_data/output/"
  }
  glue_version = "4.0"
  number_of_workers = 2
  worker_type = "G.1X"
}