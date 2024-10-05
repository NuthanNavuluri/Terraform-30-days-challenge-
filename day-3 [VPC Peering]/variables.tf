variable "vpc_name-1" {
  description = "The name of VPC"
  type        = string
}

variable "vpc_name-2" {
  description = "The name of VPC"
  type        = string
}

variable "subnet-1" {
  description = "The name of subnet-1"
  type        = string
  default     = "my-subnet-1"
}

variable "subnet-2" {
  description = "The name of subnet-2"
  type        = string
  default     = "my-subnet-2"
}

variable "ami" {
  description = "AMI id "
  type        = string
}

variable "instance-type" {
  description = "Name of the instance type"
  type        = string
}

