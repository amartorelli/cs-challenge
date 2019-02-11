variable "vpc_cidr" {
  description = "AWS region to deploy the VPC"
  type = "string"
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "AZ for the public subnet"
  type = "map"
}

variable "private_subnets" {
  description = "AZ for the private subnet"
  type = "map"
}