#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "ram_share" {
  source = "../../"

  name = "example-org-share"

  # Organization principal example
  principals = [
    "arn:aws:organizations::111111111111:organization/o-1234567890" # Replace with actual org ARN
  ]

  # Example resources to share - using proper ARN format
  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-1234567890abcdef0"
  ]

  allow_external_principals = false

  tags = {
    Environment = "example"
    Purpose     = "organization-sharing"
  }
}
