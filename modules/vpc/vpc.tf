# create VPC
resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
}

# create IGW to allow traffic for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "VPC Internet Gateway"
  }
}

resource "aws_eip" "nat" {
  vpc      = true
}

# create a NAT gateway for the private subnets
resource "aws_nat_gateway" "natgw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.nat.id}"

  tags = {
    Name = "gw NAT"
  }
}

# create the route table entry to use the IGW as default route
resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "Default IGW"
  }
}

# create a route to allow private instances to reach the internet via the NAT GW
resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.main.id}"

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.natgw.id}"
  }

  tags {
    Name = "Default NAT GW"
  }
}