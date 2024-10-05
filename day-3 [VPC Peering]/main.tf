provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = var.vpc_name-1
  }
}
resource "aws_vpc" "my_vpc-2" {
  cidr_block = "11.0.0.0/16"
  tags = {
    Name = var.vpc_name-2
  }
}

resource "aws_subnet" "my_subnet_1" {
  vpc_id            = aws_vpc.my_vpc-1.id
  cidr_block        = "10.0.0.0/17"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-1"
  }
}

resource "aws_subnet" "my_subnet_2" {
  vpc_id            = aws_vpc.my_vpc-2.id
  cidr_block        = "11.0.0.0/17"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "subnet-2"
  }
}

resource "aws_internet_gateway" "my_igw-1" {
  vpc_id = aws_vpc.my_vpc-1.id
  tags = {
    Name = "my_internet_gateway-1"
  }
}

resource "aws_internet_gateway" "my_igw-2" {
  vpc_id = aws_vpc.my_vpc-2.id
  tags = {
    Name = "my_internet_gateway-2"
  }
}

resource "aws_route_table" "my_route_table-1" {
  vpc_id = aws_vpc.my_vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw-1.id
  }
}

resource "aws_route_table" "my_route_table-2" {
  vpc_id = aws_vpc.my_vpc-2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw-2.id
  }
}


resource "aws_route_table_association" "my_rta-1" {
  subnet_id      = aws_subnet.my_subnet_1.id
  route_table_id = aws_route_table.my_route_table-1.id
}

resource "aws_route_table_association" "my_rta-2" {
  subnet_id      = aws_subnet.my_subnet_2.id
  route_table_id = aws_route_table.my_route_table-2.id
}

resource "aws_security_group" "my_sg-1" {
  vpc_id = aws_vpc.my_vpc-1.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc-2.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_security_group"
  }
}

resource "aws_security_group" "my_sg-2" {
  vpc_id = aws_vpc.my_vpc-2.id
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.my_vpc-1.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_security_group"
  }
}

resource "aws_instance" "web_server_1" {
  ami           = var.ami
  instance_type = var.instance-type
  subnet_id     = aws_subnet.my_subnet_1.id
  security_groups = [aws_security_group.my_sg-1.id]

  tags = {
    Name = "web_server_1"
  }
}

resource "aws_instance" "web_server_2" {
  ami           = var.ami
  instance_type = var.instance-type
  subnet_id     = aws_subnet.my_subnet_2.id
  security_groups = [aws_security_group.my_sg-2.id]

  tags = {
    Name = "web_server_2"
  }
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = aws_vpc.my_vpc-1.id
  peer_vpc_id   = aws_vpc.my_vpc-2.id
  auto_accept   = true
  peer_owner_id = data.aws_caller_identity.current.account_id  # For same AWS account

  tags = {
    Name = "vpc-peer"
  }
}

data "aws_caller_identity" "current" {}

# Route for VPC 1 to access VPC 2 via peering
resource "aws_route" "vpc1_to_vpc2" {
  route_table_id         = aws_route_table.my_route_table-1.id
  destination_cidr_block = aws_vpc.my_vpc-2.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}

# Route for VPC 2 to access VPC 1 via peering
resource "aws_route" "vpc2_to_vpc1" {
  route_table_id         = aws_route_table.my_route_table-2.id
  destination_cidr_block = aws_vpc.my_vpc-1.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
}
