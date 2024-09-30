provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "rds_sg" {
  name        = "db-sg"
  description = "Allow MySQL access"
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allows access from anywhere; change for more restrictive access.
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "mydb" {
  allocated_storage    = 20                  
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class                
  username             = "admin"               
  password             = var.db_password       
  parameter_group_name = "default.mysql8.0"    
  publicly_accessible  = true                  
  vpc_security_group_ids = [aws_security_group.rds_sg.id]  # Attach security group
  skip_final_snapshot  = true

  # Optional: Multi-AZ for high availability (set to true for production)
  multi_az = false
}



