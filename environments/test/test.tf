provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
    source = "../../modules/vpc"

    public_subnets = {
        "eu-west-1a" = "10.0.1.0/24"
        "eu-west-1b" = "10.0.2.0/24"
    }
    private_subnets = {
        "eu-west-1a" = "10.0.4.0/24"
        "eu-west-1b" = "10.0.5.0/24"
    }
}

module "data" {
    source = "../../modules/data"

    bucket_name = "clearscore-website"
}

module "web" {
    source = "../../modules/web"
    
    vpc_id = "${module.vpc.vpc_id}"
    sg_ssh_cidr = ["0.0.0.0/0"]
    private_subnets = "${module.vpc.private_subnets}"
    public_subnets = "${module.vpc.public_subnets}"
    key_name = "imac"
    s3_read_access_policy = "${module.data.s3_read_access_policy}"
    max_instances = "1"
}
