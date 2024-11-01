# Define variables
variable "region" {
  description = "The AWS region to deploy resources"
  default     = "us-east-1"
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for public subnet 1"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for public subnet 2"
  default     = "10.0.2.0/24"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for private subnet 1"
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for private subnet 2"
  default     = "10.0.4.0/24"
}

variable "web_instance_ami" {
  description = "AMI ID for web server instances"
  default     = "ami-0583d8c7a9c35822c"  
}

variable "app_instance_ami" {
  description = "AMI ID for application server instances"
  default     = "ami-0583d8c7a9c35822c"  
}

variable "master_username" {
  description = "Database username"
  default     = "jonas"
}

variable "master_password" {
  description = "Database password"
  default     = "Malden62" 
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}