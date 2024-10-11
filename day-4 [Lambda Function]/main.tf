
provider "aws" {
  region = "us-east-1"  # Replace with your preferred AWS region
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket-1" {
  bucket = var.test-bucket-1  # Ensure this bucket name is globally unique
}

# Create an S3 bucket
resource "aws_s3_bucket" "my_bucket-2" {
  bucket = var.test-bucket-2  # Ensure this bucket name is globally unique
}

# Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = var.lambda_function_name 
  role          = "arn:aws:iam::084828582184:role/service-role/s3-lambda"  
  handler       = "lambda_function.lambda_handler"  # Python handler function
  runtime       = "python3.12"  # Python runtime

  # Location of the function code (can be local or S3)
  filename      = "lambda_function.zip"  # Assuming the code is packaged as a .zip file

  # Define the memory and timeout
  memory_size   = 128
  timeout       = 10  # Timeout in seconds
}

# Grant S3 permission to invoke the Lambda function
resource "aws_lambda_permission" "allow_s3_to_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "s3.amazonaws.com"

  # Specify the source (S3 bucket)
  source_arn = aws_s3_bucket.my_bucket-1.arn
}

# S3 bucket notification to trigger Lambda on object creation
resource "aws_s3_bucket_notification" "my_bucket_notification" {
  bucket = aws_s3_bucket.my_bucket-1.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.my_lambda.arn
    events              = ["s3:ObjectCreated:*"]  # Trigger on all object creation events
  }

  # Depends on lambda permission to ensure proper ordering
  depends_on = [aws_lambda_permission.allow_s3_to_invoke]
}


