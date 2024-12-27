<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-ram/blob/main/docs/banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/ram/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-ram/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-ram.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-ram/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-ram.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-ram/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS RAM (Resource Access Manager)

## Description

The purpose of this module is to provide a building block for using AWS RAM (Resource Access Manager) to share (supported) AWS Resources across multiple accounts .

## Usage

See [examples](examples) for use cases

```hcl
module "ram_ssm_param" {
  source  = "appvia/ram/aws"
  version = "0.0.1"

  name = "share-ssm-parameter-within-org"

  # Resource ARN for the SSM parameter to share
  resource_arns = [
    "arn:aws:ssm:eu-west-2:123456789101:parameter/something_important"
  ]

  # Organization principal ARN
  principals = [
    "arn:aws:organizations::101987654321:organization/o-abcdef1234"
  ]

  # Since we're sharing within org, keep external principals disabled
  allow_external_principals = false

  tags = {
    Purpose = "SSM Parameter Sharing"
    Scope   = "Organization"
  }
}

```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the resource share | `string` | n/a | yes |
| <a name="input_principals"></a> [principals](#input\_principals) | The principals to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN. | `list(string)` | n/a | yes |
| <a name="input_resource_arns"></a> [resource\_arns](#input\_resource\_arns) | List of Amazon Resource Names (ARNs) of the resources to associate with the RAM share. | `list(string)` | n/a | yes |
| <a name="input_allow_external_principals"></a> [allow\_external\_principals](#input\_allow\_external\_principals) | Indicates whether principals outside your organization can be associated with a resource share. Default is false for security best practices. | `bool` | `false` | no |
| <a name="input_permission_arns"></a> [permission\_arns](#input\_permission\_arns) | Specifies the Amazon Resource Names (ARNs) of the RAM permissions to associate with the resource share.<br/>If not specified, RAM automatically attaches the default version of the permission for each resource type.<br/>Only one permission can be associated with each resource type included in the resource share. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Key-value map of tags to assign to the RAM share resource. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_accepter_status"></a> [accepter\_status](#output\_accepter\_status) | Status of the resource share accepter |
| <a name="output_resource_association_arns"></a> [resource\_association\_arns](#output\_resource\_association\_arns) | ARNs of the resource associations |
| <a name="output_resource_share_arn"></a> [resource\_share\_arn](#output\_resource\_share\_arn) | ARN of the resource share |
<!-- END_TF_DOCS -->
