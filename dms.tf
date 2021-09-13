resource "random_id" "id" {
  byte_length = 8
}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "replication-subnet-group" {
  replication_subnet_group_description = "Replication subnet group for ${var.application}"
  replication_subnet_group_id          = "dms-subnet-group-${random_id.id.hex}"

  subnet_ids = [
    "subnet-008096de384cdb660",
    "subnet-042d27892b9d249dc",
    "subnet-07fa62f055b2bcfce",
  ]

  tags = {
    Name        = "${var.team_name} DMS subnet group"
    Description = "Managed by Terraform"
    Env         = var.environment-name
    Owner       = var.team_name
    namespace   = var.namespace
  }
}

# Create a new replication instance
resource "aws_dms_replication_instance" "replication-instance" {
  allocated_storage           = 20
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  engine_version              = "3.1.3"
  publicly_accessible         = false
  replication_instance_class  = "dms.t2.medium"
  replication_instance_id     = "dms-replication-instance-${random_id.id.hex}"
  replication_subnet_group_id = aws_dms_replication_subnet_group.replication-subnet-group.id

  tags = {
    Name        = "${var.team_name} Replication Instance"
    Description = "Managed by Terraform"
    Env         = var.environment-name
    Application = var.application
    Owner       = var.team_name
  }
}
