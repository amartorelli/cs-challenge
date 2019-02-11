locals {
    public_subnets_keys = "${keys(var.public_subnets)}"
    private_subnets_keys = "${keys(var.private_subnets)}"
}