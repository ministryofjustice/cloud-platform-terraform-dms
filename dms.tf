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
    Env         = "${var.environment-name}"
    Owner       = "${var.team_name}"
    namespace   = "${var.namespace}"
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
  replication_subnet_group_id = "${aws_dms_replication_subnet_group.replication-subnet-group.id}"

  tags = {
    Name        = "${var.team_name} Replication Instance"
    Description = "Managed by Terraform"
    Env         = "${var.environment-name}"
    Application = "${var.application}"
    Owner       = "${var.team_name}"
  }
}

# Create a new source endpoint
resource "aws_dms_endpoint" "source" {
  endpoint_id                 = "dms-source-endpoint-${random_id.id.hex}"
  endpoint_type               = "source"
  engine_name                 = "postgres"
  extra_connection_attributes = ""
  server_name                 = "${var.source_database_host}"
  database_name               = "${var.source_database_name}"
  username                    = "${var.source_database_username}"
  password                    = "${var.source_database_password}"
  port                        = 5432
  ssl_mode                    = "require"

  tags = {
    Name        = "${var.team_name} Source Endpoint"
    Description = "Managed by Terraform"
    Application = "${var.application}"
    Owner       = "${var.team_name}"
    Env         = "${var.environment-name}"
  }
}

# Create a new target endpoint
resource "aws_dms_endpoint" "target" {
  endpoint_id                 = "dms-target-endpoint-${random_id.id.hex}"
  endpoint_type               = "target"
  engine_name                 = "postgres"
  extra_connection_attributes = ""
  server_name                 = "${var.target_database_host}"
  database_name               = "${var.target_database_name}"
  username                    = "${var.target_database_username}"
  password                    = "${var.target_database_password}"
  port                        = 5432
  ssl_mode                    = "require"

  tags = {
    Name        = "${var.team_name} Target Endpoint"
    Description = "Managed by Terraform"
    Application = "${var.application}"
    Env         = "${var.environment-name}"
    Owner       = "${var.team_name}"
  }
}

data "local_file" "replication-tasks-settings" {
  filename = "${path.module}/resources/settings.tmpl"
}

# Create a new replication task
resource "aws_dms_replication_task" "replication-task" {
  migration_type           = "full-load-and-cdc"
  replication_instance_arn = "${aws_dms_replication_instance.replication-instance.replication_instance_arn}"
  replication_task_id      = "dms-replication-task-${random_id.id.hex}"

  source_endpoint_arn = "${aws_dms_endpoint.source.endpoint_arn}"
  target_endpoint_arn = "${aws_dms_endpoint.target.endpoint_arn}"

  table_mappings            = "{\"rules\":[{\"rule-type\":\"selection\",\"rule-id\":\"1\",\"rule-name\":\"1\",\"object-locator\":{\"schema-name\":\"%\",\"table-name\":\"%\"},\"rule-action\":\"include\"}]}"
  replication_task_settings = "${data.local_file.replication-tasks-settings.content}"

  tags = {
    Name        = "${var.team_name} Replication Task"
    Owner       = "${var.team_name}"
    Application = "${var.application}"
    Description = "Managed by Terraform"
    Env         = "${var.environment-name}"
  }
}
