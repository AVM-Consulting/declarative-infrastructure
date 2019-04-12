// Create S3 for Kops State
resource "aws_s3_bucket" "k8-state"{
  bucket = "${local.s3_kops_state}"
  acl = "private"
  force_destroy = true
  tags = "${merge(local.tags)}"
}

// Create Security Group

resource "aws_security_group" "k8-blog-sg"{

  name = "blog-${local.domain_name}"
  vpc_id = "${module.blog_vpc.vpc_id}"
  tags = "${merge(local.tags)}"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["${local.ingress_ips}"]
  }

  ingress {

    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["${local.ingress_ips}"]

  }

}