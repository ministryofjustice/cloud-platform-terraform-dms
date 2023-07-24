output "replication_instance_arn" {
  description = "Amazon Resource Name (ARN) of the replication instance"
  value       = aws_dms_replication_instance.replication-instance.replication_instance_arn
}

output "irsa_policy_arn" {
  description = "IAM policy ARN for access to the DMS replication instance"
  value       = aws_iam_policy.irsa.arn
}
