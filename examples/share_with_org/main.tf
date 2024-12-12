#####################################################################################
# Terraform module examples are meant to show an _example_ on how to use a module
# per use-case. The code below should not be copied directly but referenced in order
# to build your own root module that invokes this module
#####################################################################################

module "share_with_org" {
  source        = "../../"
  name          = "share ssm parameter within org"
  resource_arns = ["arn:aws:ssm:eu-west-2:123456789101:parameter/something_important"]
  principals    = ["arn:aws:organizations::101987654321:organization/o-abcdef1234"]
}

module "ssm_read_only" {
  source          = "../../"
  name            = "share ssm parameter with read only permissions"
  resource_arns   = ["arn:aws:ssm:eu-west-1:987654321101:parameter/parameter_name"]
  principals      = ["55555555555"]
  permission_arns = ["arn:aws:ram::aws:permission/AWSRAMDefaultPermissionSSMParameterReadOnly"]
}

module "ssm_read_only_with_history" {
  source          = "../../"
  name            = "share ssm parameter with read only permissions with history"
  resource_arns   = ["arn:aws:ssm:eu-west-1:987654321101:parameter/parameter_name"]
  principals      = ["55555555555"]
  permission_arns = ["arn:aws:ram::aws:permission/AWSRAMPermissionSSMParameterReadOnlyWithHistory"]
}