variable "region" {
  description = "The name of Region"
  type        = string
  
}

variable "vpc_name" {
  description = "The name of VPC"
  type        = string
  default     = "my-vpc"
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

variable "az-1" {
  description = "The name of availability_zone_1"
  type        = string
  default     = "us-east-1a"
}

variable "az-2" {
  description = "The name of availability_zone_2"
  type        = string
  default     = "us-east-1b"
}

variable "ami" {
  description = "AMI id "
  type        = string
}

variable "instance-type" {
  description = "Name of the instance type"
  type        = string
  default     = "t2.micro"
}


