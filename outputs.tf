output "resource_share_arn" {
  description = "ARN of the resource share"
  value       = aws_ram_resource_share.this.arn
}

output "resource_association_arns" {
  description = "ARNs of the resource associations"
  value       = { for idx, assoc in aws_ram_resource_association.this : idx => assoc.id }
}

output "accepter_status" {
  description = "Status of the resource share accepter"
  value       = try(aws_ram_resource_share_accepter.this[0].status, null)
}
