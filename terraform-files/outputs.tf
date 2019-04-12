output "region" {
  value = "${data.aws_region.current.name}"
}

output "vpc_id" {
  value = "${module.blog_vpc.vpc_id}"
}

output "vpc_name" {
  value = "${local.vpc_name}"
}

output "vpc_cidr_block" {
  value = "${module.blog_vpc.vpc_cidr_block}"
}

// Public Subnets

output "public_subnet_ids" {
  value = ["${module.blog_vpc.public_subnets}"]
}

output "public_route_table_ids" {
  value = ["${module.blog_vpc.public_route_table_ids}"]
}

// Private Subnets

output "private_subnet_ids" {
  value = ["${module.blog_vpc.private_subnets}"]
}

output "private_route_table_ids" {
  value = ["${module.blog_vpc.private_route_table_ids}"]
}

output "default_security_group_id" {
  value = "${module.blog_vpc.default_security_group_id}"
}

output "nat_gateway_ids" {
  value = "${module.blog_vpc.natgw_ids}"
}

output "availability_zones" {
  value = ["${local.zones}"]
}

output "common_http_sg_id" {
  value = "${aws_security_group.k8-blog-sg.id}"
}

// Needed for kops

output "kops_s3_bucket" {
  value = "${aws_s3_bucket.k8-state.bucket}"
}

output "kubernetes_cluster_name" {
  value = "${local.k8_cluster_name}"
}