# create a set of public subnets to expose our services
resource "aws_subnet" "public" {
  count = "${length(local.public_subnets_keys)}"
  vpc_id     = "${aws_vpc.main.id}"
  availability_zone = "${element(local.public_subnets_keys, count.index)}"
  cidr_block = "${
    lookup(
      var.public_subnets,
      element(local.public_subnets_keys, count.index)
    )
  }"

  tags = {
    Name = "${
      format(
        "subnet-public-%s",
        element(
          keys(var.public_subnets),
          count.index
        )
      )
    }"
  }
}

# create an association with the routing table for each public subnet
resource "aws_route_table_association" "public" {
  count = "${length(local.public_subnets_keys)}"
  subnet_id = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

# create a set of private subnets for the backend services
resource "aws_subnet" "private" {
  count = "${length(local.private_subnets_keys)}"
  vpc_id     = "${aws_vpc.main.id}"
  availability_zone = "${element(local.private_subnets_keys, count.index)}"
  cidr_block = "${
    lookup(
      var.private_subnets,
      element(local.private_subnets_keys, count.index)
    )
  }"

  tags = {
    Name = "${
      format(
        "subnet-private-%s",
        element(
          keys(var.private_subnets),
          count.index
        )
      )
    }"
  }
}

# NAT subnet
resource "aws_subnet" "nat" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "10.0.10.0/24"

  tags = {
    Name = "subnet-nat"
  }
}

# associate the routing table with the NAT to the private subnets
resource "aws_route_table_association" "private-nat" {
  count = "${length(local.private_subnets_keys)}"
  subnet_id = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.nat.id}"
}

# associates the NAT public subnet to the IGW
resource "aws_route_table_association" "nat-internet" {
  subnet_id = "${aws_subnet.nat.id}"
  route_table_id = "${aws_route_table.public.id}"
}