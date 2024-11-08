locals {
  engine           = "PostgreSQL"
  this_instance_id = var.create_instance ? concat(alicloud_db_instance.this[*].id, [""])[0] : var.existing_instance_id
  project          = "acs_rds_dashboard"
}
module "databases" {
  source = "./modules/database"

  create_database   = var.create_database
  create_account    = var.create_account
  db_instance_id    = local.this_instance_id
  account_password  = var.account_password
  account_type      = var.account_type
  account_name      = var.account_name
  account_privilege = var.account_privilege
  databases         = var.databases
}

resource "alicloud_db_instance" "this" {
  count                = var.create_instance ? 1 : 0
  engine               = local.engine
  engine_version       = var.engine_version
  instance_type        = var.instance_type
  instance_storage     = var.instance_storage
  instance_charge_type = var.instance_charge_type
  instance_name        = var.instance_name
  period               = var.period
  security_ips         = length(var.security_ips) > 0 ? var.security_ips : null
  vswitch_id           = var.vswitch_id
  ssl_action           = var.ssl_action
  tags = merge(
    {
      Name          = var.instance_name
      Engine        = local.engine
      EngineVersion = var.engine_version
    },
    var.tags,
  )
  security_group_ids = var.security_group_ids
}

resource "alicloud_db_backup_policy" "this" {
  count                       = var.create_backup_policy ? 1 : 0
  instance_id                 = local.this_instance_id
  backup_retention_period     = var.backup_retention_period
  preferred_backup_time       = var.preferred_backup_time
  preferred_backup_period     = var.preferred_backup_period
  log_backup_retention_period = var.log_backup_retention_period
  enable_backup_log           = var.enable_backup_log
}

resource "alicloud_db_connection" "db_connection" {
  count             = var.allocate_public_connection && var.connection_prefix != "" ? 1 : 0
  instance_id       = local.this_instance_id
  connection_prefix = var.connection_prefix
  port              = var.port
}

resource "alicloud_cms_alarm" "cpu_usage" {
  count              = var.enable_alarm_rule ? 1 : 0
  enabled            = var.enable_alarm_rule
  name               = var.alarm_rule_name
  project            = local.project
  metric             = "CpuUsage"
  metric_dimensions  = "[{\"instanceId\":\"${local.this_instance_id}\",\"device\":\"/dev/vda1\"}]"
  period             = var.alarm_rule_period
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
  escalations_critical {
    statistics          = var.alarm_rule_statistics
    comparison_operator = var.alarm_rule_operator
    threshold           = var.alarm_rule_threshold
    times               = var.alarm_rule_triggered_count
  }
}

resource "alicloud_cms_alarm" "connection_usage" {
  count              = var.enable_alarm_rule ? 1 : 0
  enabled            = var.enable_alarm_rule
  name               = var.alarm_rule_name
  project            = local.project
  metric             = "ConnectionUsage"
  metric_dimensions  = "[{\"instanceId\":\"${local.this_instance_id}\",\"device\":\"/dev/vda1\"}]"
  period             = var.alarm_rule_period
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
  escalations_critical {
    statistics          = var.alarm_rule_statistics
    comparison_operator = var.alarm_rule_operator
    threshold           = var.alarm_rule_threshold
    times               = var.alarm_rule_triggered_count
  }
}
resource "alicloud_cms_alarm" "disk_usage" {
  count              = var.enable_alarm_rule ? 1 : 0
  enabled            = var.enable_alarm_rule
  name               = var.alarm_rule_name
  project            = local.project
  metric             = "DiskUsage"
  metric_dimensions  = "[{\"instanceId\":\"${local.this_instance_id}\",\"device\":\"/dev/vda1\"}]"
  period             = var.alarm_rule_period
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
  escalations_critical {
    statistics          = var.alarm_rule_statistics
    comparison_operator = var.alarm_rule_operator
    threshold           = var.alarm_rule_threshold
    times               = var.alarm_rule_triggered_count
  }
}

