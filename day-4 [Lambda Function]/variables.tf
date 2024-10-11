# variable names
variable "test-bucket-1" {
  description = "The name of VPC"
  type        = string
}

variable "test-bucket-2" {
  description = "The name of VPC"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of subnet-1"
  type        = string
  default     = "my-subnet-1"
}
