variable "vpc_id" {
  description = "VPC ID to use"
  type = "string"
}

variable "ami" {
    description = "AWS AMI to use for the webserver"
    type = "string"
    default = "ami-00035f41c82244dab"
}

variable "instance_type" {
    description = "instance type to use for the webservers"
    type = "string"
    default = "t2.micro"
}

variable "sg_ssh_cidr" {
    description = "The CIDR allowed to SSH"
    type = "list"
}

variable "private_subnets" {
    description = "The list of private subnets where to deploy the webserver"
    type = "list"
}


variable "public_subnets" {
    description = "The list of public subnets used for the ELB"
    type = "list"
}

variable "key_name" {
    description = "The name of the key pair to use when launching instances"
    type = "string"
}

variable "s3_read_access_policy" {
  description = "The ARN of the S3 policy to use to access S3 for the website content"
  type = "string"
}

variable "min_instances" {
  description = "The minimum number of webserver instances to have"
  type = "string"
  default = "1"
}

variable "max_instances" {
  description = "The maximum number of webserver instances to have"
  type = "string"
  default = "1"
}

variable "alarm_metric" {
  description = "The name of the metric to use"
  type = "string"
  default = "CPUUtilization"
}

variable "alarm_period" {
  description = "The period to analyse before triggering the alarm"
  type = "string"
  default = "120"
}

variable "alarm_scale_up_threshold" {
  description = "The threshold in % to use for the alarm to scale up"
  type = "string"
  default = "80"
}

variable "alarm_scale_down_threshold" {
  description = "The threshold in % to use for the alarm to scale down"
  type = "string"
  default = "20"
}

variable "alarm_scaling_adjustment" {
  description = "The number of instances to spin up/destroy when scaling"
  type = "string"
  default = "1"
}