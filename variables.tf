variable "bucket_name" {
  default = "sagar-employees-bucket"
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  description = "Environment name (dev or prod)"
  type        = string
  default     = "dev"
}