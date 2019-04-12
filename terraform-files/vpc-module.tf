// Craete VPC using Module
module "blog_vpc" {
  source              = "terraform-aws-modules/vpc/aws"
  version             = "1.60.0"
  name                = "${local.vpc_name}"
  cidr                = "14.0.0.0/16"

  azs                 = ["${local.zones}"]
  private_subnets     = ["14.0.1.0/24", "14.0.2.0/24", "14.0.3.0/24"]
  public_subnets      = ["14.0.101.0/24", "14.0.102.0/24", "14.0.103.0/24"]
  enable_nat_gateway  = true

  tags = {

    // Tags to support Kops
    "kubernetes.io/cluster/${local.k8_cluster_name}"          = "shared"
    "terraform"                                               = true
    "environment"                                             = "blog"
  }

  // Tags required by k8s Ref https://github.com/terraform-aws-modules/terraform-aws-vpc
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = true
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = true
  }

}