variable "name" {
  type        = string
  description = "The name of the resource share"
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "Resource share name must be between 1 and 64 characters."
  }
}

variable "allow_external_principals" {
  type        = bool
  default     = false
  description = "Indicates whether principals outside your organization can be associated with a resource share. Default is false for security best practices."
}

variable "principals" {
  type        = list(string)
  description = "The principals to associate with the resource share. Possible values are an AWS account ID, an AWS Organizations Organization ARN, or an AWS Organizations Organization Unit ARN."
  validation {
    condition = alltrue([
      for p in var.principals :
      can(regex("^(arn:aws:organizations::[0-9]{12}:(organization|ou)/[a-z0-9-]+(/[a-z0-9-]+)?|[0-9]{12})$", p))
    ])
    error_message = "Invalid principal format. Must be either an AWS account ID (12 digits) or an Organizations ARN (organization/OU)."
  }
}

variable "resource_arns" {
  type        = list(string)
  description = "List of Amazon Resource Names (ARNs) of the resources to associate with the RAM share."
  validation {
    condition     = length(var.resource_arns) > 0
    error_message = "At least one resource ARN must be provided."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Key-value map of tags to assign to the RAM share resource."
  validation {
    condition     = length(var.tags) <= 50
    error_message = "AWS supports a maximum of 50 tags per resource."
  }
}

variable "permission_arns" {
  type        = list(string)
  default     = []
  description = <<-EOT
    Specifies the Amazon Resource Names (ARNs) of the RAM permissions to associate with the resource share.
    If not specified, RAM automatically attaches the default version of the permission for each resource type.
    Only one permission can be associated with each resource type included in the resource share.
  EOT
  validation {
    condition = alltrue([
      for arn in var.permission_arns :
      can(regex("^arn:aws:ram::[0-9]{12}:permission/.+$", arn))
    ])
    error_message = "Invalid permission ARN format. Must be a valid RAM permission ARN."
  }
}
