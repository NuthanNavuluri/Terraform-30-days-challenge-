variable "region" {
    description = "Name of the region"
    type = string
    default = "us-east-1"
}

variable "instance_class" {    
    description = "Name of the instance_class"
    type = string
}

variable "db_password" {
    description = "password"
    type = string
    sensitive   = true
}
