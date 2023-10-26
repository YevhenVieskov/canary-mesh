# Define common tags to be used for all (supported) resources
locals {
  common_tags = {
    BuiltWith = "terraform"
  }

  default_tags = "${merge(
    local.common_tags,
    tomap(
      {Name="${var.service_name}",
      Environment="${var.environment}"}
    )
  )}"
}
