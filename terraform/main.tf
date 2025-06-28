provider "aws" {
  region = "us-west-1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = "react-node-cluster"
  cluster_version = "1.27"
  vpc_id          = "vpc-0e3a5e6d535fd443d" # your default VPC
  subnet_ids      = ["subnet-072ed7f29e944a741", "subnet-05cd2cfdb87d32df6"] # 2 subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 2
      desired_size   = 1
    }
  }

  create_cloudwatch_log_group = false
  cluster_enabled_log_types   = []
  manage_aws_auth_configmap   = true

}