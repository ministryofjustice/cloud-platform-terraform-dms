output "replication_instance_arn" {
  value = aws_dms_replication_instance.replication-instance.replication_instance_arn
}

output "access_key_id" {
  description = "Access key id for the credentials"
  value       = aws_iam_access_key.dms_key_2023.id
}

output "secret_access_key" {
  description = "Secret for the new credentials"
  value       = aws_iam_access_key.dms_key_2023.secret
}
