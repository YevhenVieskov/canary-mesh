variable "aws_region" {
  default = "us-west-2"
}

variable "containerPort" {
  default = 80
}

variable "app_name" {
  default = "app"
}

variable "tags" {
  type = map(any)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

