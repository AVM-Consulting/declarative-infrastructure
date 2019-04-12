# Setup Kubernetes Cluster with Terraform and Kops - PART 1
  * [Who should read this Blog:](#who-should-read-this-blog)
  * [Short introduction](#short-introduction)
      - [What is Terraform](#what-is-terraform)
      - [What is Kubernetes](#what-is-kubernetes)
      - [What is KOPS](#What-is-KOPS)
      - [What is Kubect](#What is Kubectl)
  * [Problem we are trying to solve](#problem-we-are-trying-to-solve)
  * [Stack used](#stack-used)
  * [Actual implementation](#actual-implementation)
      - [Install Terraform, Kops and Kubectl](#install-terraform-kops-and-kubectl)
      - [Setup S3, VPC and Domain using Terraform](#setup-s3-vpc-and-domain-using-terraform)
      - [Setup K8 Cluster using KOPS](#setup-k8-cluster-using-kops)
      - [Install a Smaple Application in the K8 Cluster](#install-a-smaple-application-in-the-k8-cluster)
      - [Cleanup the setup](#cleanup-the-setup)
## Who should read this Blog:
This Blog is for those who wants to quickly get an overall general understanding on setting up a container eco system 
and understand how **infrastructure as a code** looks like. this is meant for all who wants to see an working example 
of the above mentioned concepts.

This is not an advanced level tutorial. 
1) I am using **Terraform** to maintain the underlying Infrastructure which will 
the host the set of containers/pods
2) I am using **Kubernetes (K8)** as container Orchestrator
3) Using **Kops** to manage the K8 Cluster lifecycle
4) Using **AWS** as cloud provider

## Short introduction
The aim of this blog is not to give in depth knowledge of Terraform or K8. but to show an working example as a quick 
start guide
#### What is Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage 
existing and popular service providers as well as custom in-house solutions.

Pls refer : https://www.terraform.io/intro/index.html for further info

#### What is Kubernetes
K8  is an open-source system for automating deployment, scaling, and management of containerized applications. It 
groups containers that make up an application into logical units for easy management and discovery.

Pls refer : https://kubernetes.io/ for further info

#### What is KOPS
kops helps you create, destroy, upgrade and maintain production-grade, highly available, Kubernetes clusters from the 
command line. AWS (Amazon Web Services) is currently officially supported

Pls refer: https://github.com/kubernetes/kops

#### What is Kubectl
Kubectl is a command line interface for running commands against Kubernetes clusters

Pls refer: https://kubernetes.io/docs/reference/kubectl/overview/

## Problem we are trying to solve
We will launch an AWS VPC, S3 bucket and Domain using terraform which are AWS resources and use KOPS for launcing the ec2
instances of master and nodes to set up a K8 Cluster

## Stack used
* Cloud: `AWS`
* Region: `us-west-2`
* Instance Type: `t2.medium`
* OS: Ubuntu `18.04`
* AMI : `ami-005bdb005fb00e791`

Note: Please check the details before using scripts to launch it will incur some cost in the AWS 

## Actual implementation

#### Install Terraform, Kops and Kubectl
clone the repo https://github.com/dbiswas1/Terraform.git

```
git clone https://github.com/dbiswas1/terraform.git
cd Terraform
chmod 755 setup_env.sh
./setup_env.sh

###############################################
#Output will be as follows
###############################################

Hit:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Fetched 252 kB in 1s (298 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
jq is already the newest version (1.5+dfsg-2).
0 upgraded, 0 newly installed, 0 to remove and 73 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
unzip is already the newest version (6.0-21ubuntu1).
0 upgraded, 0 newly installed, 0 to remove and 73 not upgraded.
======================================================================================
[2019-04-07 08:24:17]: INFO: Start Kops Download -> Version : 1.11.1 and Flavor: kops-linux-amd64
[2019-04-07 08:24:23]: INFO: Download Complete
[2019-04-07 08:24:23]: INFO: Kops setup done -> Version : 1.11.1 and Flavor: kops-linux-amd64
======================================================================================
[2019-04-07 08:24:23]: INFO: Start Kubectl Download
[2019-04-07 08:24:24]: INFO: Download Complete
[2019-04-07 08:24:24]: INFO: Kubectl setup done -> Version : v1.14.0
======================================================================================
[2019-04-07 08:24:26]: INFO: Download Terraform -> Version 0.11.13
[2019-04-07 08:24:27]: INFO: Download Complete
Archive:  terraform_0.11.13_linux_amd64.zip
  inflating: terraform
======================================================================================
[2019-04-07 08:24:29]: INFO: VERIFY KOPS
[2019-04-07 08:24:30]: INFO: VERIFY KUBECTL
[2019-04-07 08:24:30]: INFO: VERIFY TERRAFORM
Terraform v0.11.13

[2019-04-07 08:24:30]: INFO: Validation Successful !!!
======================================================================================
```

#### Setup S3, VPC and Security Group using Terraform
* clone the repo `git clone https://github.com/dbiswas1/terraform.git`
* cd terraform-files
* `terraform init` to initialise the terraform workspace
* `terraform plan` this is a dry run where actual exceution doesnot happen but terraform shows what it will do
* `terraform graph` optional but you can check how the dependencies are
* finally `terraform apply` to execute
* giving some sample output below you would also see how terraform outputs file is helping displaying the required output
* in this terraform files we have covered how to use 
   * [data](https://www.terraform.io/docs/configuration/data-sources.html)
   * [modules](https://www.terraform.io/docs/modules/index.html)
   * [outputs](https://www.terraform.io/docs/configuration/outputs.html)
   * [local variables](https://www.terraform.io/docs/configuration/locals.html) .. we will cover more in subsequent series
* Some references 
    * https://github.com/terraform-aws-modules/terraform-aws-vpc
    
```
#########################################################################
# Output of a terraform plan
#########################################################################
ubuntu@ip-172-31-44-201:~/terraform/terraform-files$ terraform init
Initializing modules...
- module.blog_vpc
  Found version 1.60.0 of terraform-aws-modules/vpc/aws on registry.terraform.io
  Getting source "terraform-aws-modules/vpc/aws"

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (2.6.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.6"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
```
######################################################################
# output of a terraform apply 
#######################################################################
module.blog_vpc.aws_route.private_nat_gateway[1]: Creation complete after 0s (ID: r-rtb-093a778094db492241080289494)
module.blog_vpc.aws_route.private_nat_gateway[2]: Creation complete after 0s (ID: r-rtb-020cf78f454e1aba71080289494)
module.blog_vpc.aws_route.private_nat_gateway[0]: Creation complete after 0s (ID: r-rtb-0e006178f8bfa887a1080289494)

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

availability_zones = [
    us-west-2a,
    us-west-2b,
    us-west-2c
]
common_http_sg_id = sg-04bb26488f455e9a5
default_security_group_id = sg-020a829bcdc36d239
kops_s3_bucket = k8.cloudservices2go.com
kubernetes_cluster_name = blog.cloudservices2go.com
nat_gateway_ids = [
    nat-04884a9df64dc2099,
    nat-0ccbf831effb9ad2c,
    nat-05ffe724a00e92a26
]
private_route_table_ids = [
    rtb-0e006178f8bfa887a,
    rtb-093a778094db49224,
    rtb-020cf78f454e1aba7
]
private_subnet_ids = [
    subnet-03788eca5f2aa0f69,
    subnet-08f88757683c4e6d5,
    subnet-0d0508d513a0db975
]
public_route_table_ids = [
    rtb-0135b9019663b2909
]
public_subnet_ids = [
    subnet-0d605eda93449e46a,
    subnet-018aeef0867af06fb,
    subnet-0fcb2eb7dd8289fc5
]
region = us-west-2
vpc_cidr_block = 14.0.0.0/16
vpc_id = vpc-06a1a64382adb8ed4
vpc_name = blog-vpc-cloudservices2go.com

```

#### Setup K8 Cluster using KOPS
**WIP**

#### Install a Sample Application in the K8 Cluster
**WIP**

#### Cleanup the setup
**WIP**

