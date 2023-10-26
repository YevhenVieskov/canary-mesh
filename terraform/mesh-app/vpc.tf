module "sample_vpc" {
  source = "terraform-aws-modules/vpc/aws"
  //version                = "2.7.0"
  version                = "5.1.2"
  name                   = "sample_vpc"
  azs                    = ["us-west-2a", "us-west-2b", "us-west-2c"]
  cidr                   = "10.10.0.0/19"                                      # 8,192
  private_subnets        = ["10.10.0.0/22", "10.10.4.0/22", "10.10.8.0/22"]    # 1,024 each
  public_subnets         = ["10.10.28.0/24", "10.10.29.0/24", "10.10.30.0/24"] # 256 each
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  enable_vpn_gateway     = false
  enable_dns_hostnames   = true
  enable_dns_support     = true
  //enable_s3_endpoint     = true
}

module "vpc_endpoints" {
  source = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"

  vpc_id                     = module.sample_vpc.vpc_id
  create_security_group      = true
  security_group_name_prefix = "vpc-endpoints-"       //var.vpc_ep_sg_name_prefix
  security_group_description = "sg for VPC endpoints" //var.vpc_ep_sg_description
  security_group_rules = {
    ingress_https = {
      description = "ingrress rules for vpc endpoints"
      cidr_blocks = [module.sample_vpc.vpc_cidr_block]
    }
  }

  endpoints = {

    s3 = {
      service = "s3"
      tags    = { Name = "s3-vpc-endpoint" }
    },

    ecs = {
      service             = "ecs"
      private_dns_enabled = true
      subnet_ids          = module.sample_vpc.private_subnets
    },
    ecs_telemetry = {
      create              = false
      service             = "ecs-telemetry"
      private_dns_enabled = true
      subnet_ids          = module.sample_vpc.private_subnets
    },
    ecr_api = {
      service             = "ecr.api"
      private_dns_enabled = true
      subnet_ids          = module.sample_vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },

    ecr_dkr = {
      service             = "ecr.dkr"
      private_dns_enabled = true
      subnet_ids          = module.sample_vpc.private_subnets
      policy              = data.aws_iam_policy_document.generic_endpoint_policy.json
    },

    logs = {
      service             = "logs"
      private_dns_enabled = true
      subnet_ids          = module.sample_vpc.private_subnets
    },


  }

  tags = merge(var.tags, { Endpoint = "true" })
}

data "aws_iam_policy_document" "generic_endpoint_policy" {
  statement {
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:SourceVpc"

      values = [module.sample_vpc.vpc_id]
    }
  }
}
