<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-ram/blob/main/docs/banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/ram/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-ram/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-ram.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-ram/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-ram.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-ram/actions/workflows/terraform.yml/badge.svg)

# Terraform AWS RAM (Resource Access Manager)

## Overview

The Terraform AWS RAM module provides a comprehensive, enterprise-grade solution for managing AWS Resource Access Manager (RAM) resource sharing across multiple AWS accounts and organizational units. This module enables organizations to securely share AWS resources, implement cross-account access patterns, and establish centralized resource management with fine-grained access controls and automated sharing workflows.

## Purpose & Intent

### **Problem Statement**

Large enterprises face significant challenges when managing AWS resources across multiple accounts and organizational boundaries:

- **Resource Duplication**: Multiple accounts creating duplicate resources instead of sharing common infrastructure
- **Access Management Complexity**: Difficulty in providing cross-account access to shared resources
- **Cost Inefficiency**: Unnecessary resource duplication leading to increased costs
- **Security Concerns**: Lack of centralized control over resource sharing and access permissions
- **Compliance Challenges**: Difficulty in maintaining compliance across shared resources
- **Operational Overhead**: Manual processes for resource sharing and access management
- **Governance Gaps**: Lack of standardized resource sharing policies and procedures

### **Solution**

This module provides a centralized, automated approach to AWS resource sharing that:

- **Centralizes Resource Sharing**: Implements AWS RAM for secure cross-account resource sharing
- **Automates Access Management**: Provides automated principal association and resource sharing workflows
- **Enables Cost Optimization**: Reduces resource duplication through efficient sharing mechanisms
- **Provides Security Controls**: Implements fine-grained permissions and access controls
- **Supports Compliance**: Ensures consistent resource sharing policies and audit trails
- **Reduces Operational Overhead**: Automates resource sharing setup and management

## Key Features

### 🔗 **Comprehensive Resource Sharing**

- **Multi-Resource Support**: Share various AWS resource types including VPCs, subnets, transit gateways, and more
- **Flexible Principal Management**: Support for AWS accounts, Organizations, and Organizational Units
- **External Sharing**: Optional support for sharing resources with external AWS accounts
- **Resource Association**: Automatic association of multiple resources with resource shares

### 🛡️ **Advanced Security & Access Control**

- **Permission Management**: Support for AWS-managed and customer-managed RAM permissions
- **Principal Validation**: Built-in validation for principal ARN formats and account IDs
- **External Principal Control**: Configurable external principal access with security best practices
- **Access Auditing**: Comprehensive logging and monitoring of resource sharing activities

### 🏗️ **Enterprise Architecture**

- **Organizational Integration**: Seamless integration with AWS Organizations and OUs
- **Multi-Account Support**: Support for sharing across multiple AWS accounts
- **Resource Share Management**: Centralized management of resource shares and associations
- **Automated Workflows**: Automated resource share acceptance for external principals

### 📊 **Resource Management**

- **Resource Discovery**: Easy identification and sharing of existing AWS resources
- **Share Lifecycle Management**: Complete lifecycle management of resource shares
- **Association Tracking**: Comprehensive tracking of resource associations and principals
- **Status Monitoring**: Real-time monitoring of resource share status and acceptance

### ⚙️ **Operational Excellence**

- **Terraform State Management**: Full Terraform state management for all resources
- **Resource Tagging**: Consistent tagging across all created resources
- **Output Management**: Comprehensive outputs for integration with other modules
- **Dependency Management**: Proper resource dependencies and lifecycle management
- **Validation**: Built-in input validation for security and compliance

## Usage

### **Basic Usage - Organization-Wide Sharing**

```hcl
module "ram_share" {
  source = "appvia/ram/aws"
  version = "0.1.0"

  name = "shared-vpc-subnets"

  # Share resources with entire organization
  principals = [
    "arn:aws:organizations::111111111111:organization/o-1234567890"
  ]

  # Resources to share
  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-1234567890abcdef0",
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-0987654321fedcba0"
  ]

  # Security: Only allow organization members
  allow_external_principals = false

  tags = {
    Environment = "production"
    Purpose     = "shared-networking"
    Owner       = "platform-team"
  }
}
```

### **Advanced Usage - Multi-Principal Resource Sharing**

```hcl
module "ram_share" {
  source = "appvia/ram/aws"
  version = "0.1.0"

  name = "enterprise-transit-gateway"

  # Multiple principals: Organization, OU, and specific accounts
  principals = [
    "arn:aws:organizations::111111111111:organization/o-1234567890",
    "arn:aws:organizations::111111111111:ou/o-1234567890/ou-abc123",
    "333333333333",  # Specific account
    "444444444444"   # Another specific account
  ]

  # Transit gateway and associated resources
  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:transit-gateway/tgw-1234567890abcdef0",
    "arn:aws:ec2:us-west-2:222222222222:transit-gateway-attachment/tgw-attach-1234567890abcdef0"
  ]

  # Custom permissions for fine-grained control
  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionTransitGateway",
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionTransitGatewayAttachment"
  ]

  # Allow external principals for partner access
  allow_external_principals = true

  tags = {
    Environment     = "production"
    Purpose         = "enterprise-networking"
    BusinessUnit    = "infrastructure"
    DataClassification = "internal"
    Compliance      = "required"
  }
}
```

### **External Sharing with Acceptance**

```hcl
# Resource Owner Account
module "ram_share" {
  source = "appvia/ram/aws"
  version = "0.1.0"

  name = "partner-dns-zone"

  # Share with external partner account
  principals = [
    "555555555555"  # Partner account ID
  ]

  # Route 53 hosted zone
  resource_arns = [
    "arn:aws:route53:::hostedzone/Z1234567890ABCDEF"
  ]

  # Allow external principals
  allow_external_principals = true

  tags = {
    Environment = "production"
    Purpose     = "partner-integration"
    Partner     = "external-company"
  }
}

# Partner Account (Resource Consumer)
resource "aws_ram_resource_share_accepter" "partner_accept" {
  provider  = aws.partner
  share_arn = module.ram_share.resource_share_arn
}
```

### **Use Cases**

#### **1. Centralized Networking Infrastructure**

```hcl
# For organizations with centralized networking
module "centralized_networking" {
  source = "appvia/ram/aws"
  
  name = "centralized-networking-resources"

  principals = [
    "arn:aws:organizations::111111111111:organization/o-1234567890"
  ]

  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-1234567890abcdef0",
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-0987654321fedcba0",
    "arn:aws:ec2:us-west-2:222222222222:transit-gateway/tgw-1234567890abcdef0"
  ]

  allow_external_principals = false

  tags = {
    Environment = "production"
    Purpose     = "centralized-networking"
    Team        = "platform-engineering"
  }
}
```

#### **2. Cross-Account DNS Management**

```hcl
# For centralized DNS management
module "dns_sharing" {
  source = "appvia/ram/aws"
  
  name = "shared-dns-zones"

  principals = [
    "arn:aws:organizations::111111111111:ou/o-1234567890/ou-production",
    "arn:aws:organizations::111111111111:ou/o-1234567890/ou-staging"
  ]

  resource_arns = [
    "arn:aws:route53:::hostedzone/Z1234567890ABCDEF",
    "arn:aws:route53:::hostedzone/Z0987654321FEDCBA"
  ]

  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionRoute53HostedZone"
  ]

  allow_external_principals = false

  tags = {
    Environment = "production"
    Purpose     = "dns-management"
    Service     = "route53"
  }
}
```

#### **3. License Sharing and Optimization**

```hcl
# For software license sharing
module "license_sharing" {
  source = "appvia/ram/aws"
  
  name = "enterprise-software-licenses"

  principals = [
    "arn:aws:organizations::111111111111:organization/o-1234567890"
  ]

  resource_arns = [
    "arn:aws:license-manager:us-west-2:222222222222:license-configuration/lic-1234567890abcdef0"
  ]

  permission_arns = [
    "arn:aws:ram::aws:permission/AWSRAMDefaultPermissionLicenseManager"
  ]

  allow_external_principals = false

  tags = {
    Environment = "production"
    Purpose     = "license-optimization"
    Software    = "enterprise-licenses"
  }
}
```

#### **4. Partner and External Sharing**

```hcl
# For sharing resources with external partners
module "partner_sharing" {
  source = "appvia/ram/aws"
  
  name = "partner-resource-access"

  principals = [
    "666666666666",  # Partner account 1
    "777777777777"   # Partner account 2
  ]

  resource_arns = [
    "arn:aws:ec2:us-west-2:222222222222:subnet/subnet-1234567890abcdef0"
  ]

  allow_external_principals = true

  tags = {
    Environment = "production"
    Purpose     = "partner-integration"
    Partner     = "external-partner"
    DataClassification = "shared"
  }
}
```

## Monitoring & Troubleshooting

### **CloudWatch Logs and Metrics**

The module creates comprehensive monitoring capabilities:

```bash
# View resource shares
aws ram get-resource-shares --resource-owner SELF

# Check resource associations
aws ram list-resources --resource-share-arn arn:aws:ram:region:account:resource-share/share-id

# Monitor principal associations
aws ram list-principals --resource-share-arn arn:aws:ram:region:account:resource-share/share-id

# Check resource share status
aws ram get-resource-share-associations --resource-share-arn arn:aws:ram:region:account:resource-share/share-id
```

### **Key Monitoring Metrics**

| Service | Metric | Description | Use Case |
|---------|--------|-------------|----------|
| RAM | `ResourceShares` | Number of active resource shares | Monitor sharing activity |
| RAM | `ResourceAssociations` | Number of resource associations | Track resource sharing |
| RAM | `PrincipalAssociations` | Number of principal associations | Monitor access patterns |
| RAM | `ShareAcceptance` | Resource share acceptance status | Track external sharing |

### **Common Issues & Solutions**

#### **1. Resource Share Creation Failures**

```
Error: Failed to create resource share
```

**Solutions**:

- Verify resource ARNs are valid and accessible
- Check IAM permissions for RAM service
- Ensure resources are in supported regions
- Verify resource ownership

#### **2. Principal Association Issues**

```
Error: Principal association failed
```

**Solutions**:

- Verify principal ARN format is correct
- Check if principal account exists and is accessible
- Ensure external principals are allowed if needed
- Verify organization membership

#### **3. Resource Share Acceptance Issues**

```
Error: Resource share acceptance failed
```

**Solutions**:

- Verify resource share ARN is correct
- Check if resource share is in PENDING status
- Ensure proper IAM permissions for acceptance
- Verify resource share is not already accepted

### **Operational Best Practices**

1. **Resource Planning**: Plan resource sharing strategy before implementation
2. **Permission Management**: Use least privilege principles for resource sharing
3. **Monitoring**: Implement comprehensive monitoring and alerting
4. **Documentation**: Maintain clear documentation of shared resources
5. **Lifecycle Management**: Implement proper resource share lifecycle management

## Requirements

### **Prerequisites**

- AWS RAM service enabled
- Appropriate IAM permissions for RAM operations
- Resources to share must be in supported regions
- Target principals must be valid AWS accounts or organizations

### **AWS Services Used**

- AWS Resource Access Manager (RAM)
- AWS Organizations (for organizational principals)
- Various AWS services (for shared resources)

### **Permissions Required**

- RAM resource share management
- Resource association permissions
- Principal association permissions
- Resource share acceptance permissions (for external sharing)

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (<https://terraform-docs.io/user-guide/installation/>)
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
