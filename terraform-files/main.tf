provider "aws" {
  region = "us-west-2"
}

locals {
  zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  domain_name = "cloudservices2go.com"
  s3_kops_state = "k8.${local.domain_name}"
  k8_cluster_name = "blog.${local.domain_name}"
  ingress_ips = ["14.0.0.80/32" , "14.0.0.81/32"]
  vpc_name = "blog-vpc-${local.domain_name}"
  tags ={

    terraform = true
  }
}


data "aws_region" "current" {}