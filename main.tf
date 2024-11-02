# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
   Name = "Riverside VPC Project"
 }
}

# Create public subnets
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_1_cidr
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name  = "Riverside_subnet_public_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_2_cidr
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name  = "Riverside_subnet_public_2"
  }
}

# Create private subnets
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name  = "Riverside_subnet_private_1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"
  tags = {
    Name  = "Riverside_subnet_private_2"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

# Security Groups
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instances for Web Layer
resource "aws_instance" "web_1" {
  ami           = var.web_instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_1.id
  tags= {
    Name = Riverside_web1
  }
  #security_groups = [aws_security_group.web_sg.name]
}

resource "aws_instance" "web_2" {
  ami           = var.web_instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_2.id
  tags= {
    Name = Riverside_web2
  }
  #security_groups = [aws_security_group.web_sg.name]
}

# EC2 Instances for Application Layer
resource "aws_instance" "app_1" {
  ami           = var.app_instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_1.id
   tags= {
    Name = Riverside_app1
  }
  #security_groups = [aws_security_group.app_sg.name]
}

resource "aws_instance" "app_2" {
  ami           = var.app_instance_ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_2.id
  tags= {
    Name = Riverside_app2
  }
  #security_groups = [aws_security_group.app_sg.name]
}

# RDS Instance for Database Layer
resource "aws_db_instance" "db" {
  identifier         = "mydb"
  engine             = "postgres"
  instance_class     = "db.t3.micro"
  storage_type        = "gp2"
  allocated_storage   = 20
  engine_version     = "16.3"
  username           = var.master_username
  password           = var.master_password
  db_name            = "mydatabase"
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "main" {
  name       = "mydb-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}



