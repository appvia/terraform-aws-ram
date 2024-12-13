locals {
  # Separate principals into org and external based on ARN pattern
  org_principals = {
    for idx, principal in var.principals :
    idx => principal if length(regexall("^arn:aws:organizations::", principal)) > 0
  }
  external_principals = {
    for idx, principal in var.principals :
    idx => principal if length(regexall("^arn:aws:organizations::", principal)) == 0
  }
  needs_accepter = length(local.external_principals) > 0
}

resource "aws_ram_resource_share" "this" {
  name                      = var.name
  allow_external_principals = var.allow_external_principals
  permission_arns           = try(var.permission_arns, [])
  tags                      = can(var.tags) ? merge({ "Name" = var.name }, var.tags) : { "Name" = var.name }
}

resource "aws_ram_resource_association" "this" {
  for_each = { for idx, arn in var.resource_arns : idx => arn }

  resource_arn       = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

# Accepter only created when there are external principals
resource "aws_ram_resource_share_accepter" "this" {
  count     = local.needs_accepter ? 1 : 0
  share_arn = aws_ram_resource_share.this.arn
}

# Split the principal associations based on type
resource "aws_ram_principal_association" "org" {
  for_each = local.org_principals

  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}

resource "aws_ram_principal_association" "external" {
  for_each = local.external_principals

  depends_on         = [aws_ram_resource_share_accepter.this]
  principal          = each.value
  resource_share_arn = aws_ram_resource_share.this.arn
}
