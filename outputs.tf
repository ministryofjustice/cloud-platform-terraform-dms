output "replication_instance_arn" {
  description = "Amazon Resource Name (ARN) of the replication instance"
  value       = aws_dms_replication_instance.replication-instance.replication_instance_arn
}

output "access_key_id" {
  description = "Access key ID for the credentials"
  value       = aws_iam_access_key.dms_key.id
  sensitive   = true
}

output "secret_access_key" {
  description = "Secret for the credentials"
  value       = aws_iam_access_key.dms_key.secret
  sensitive   = true
}
