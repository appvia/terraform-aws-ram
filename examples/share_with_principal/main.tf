#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "ram_share" {
  source = "../../"

  name = "example-external-share"

  # External principal example - using 12-digit account ID
  principals = [
    "111111111111" # Replace with actual account ID
  ]

  # Example resources to share - using proper ARN format
  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-1234567890abcdef0"
  ]

  allow_external_principals = true

  tags = {
    Environment = "example"
    Purpose     = "external-sharing"
  }

  # Optional: If you need specific permissions
  permission_arns = [
    "arn:aws:ram::111111111111:permission/AWSRAMDefaultPermissionSubnet"
  ]
}

resource "aws_ram_resource_share_accepter" "receiver_accept" {
  provider  = aws.accepter
  share_arn = module.ram_share.resource_share_arn
}
