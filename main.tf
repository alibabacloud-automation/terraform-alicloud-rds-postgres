provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/rds-postgres"
}

locals {
  engine                = "PostgreSQL"
  this_instance_id      = var.existing_instance_id != "" ? var.existing_instance_id : concat(alicloud_db_instance.this.*.id, [""])[0]
  create_more_resources = var.existing_instance_id != "" || var.create_instance ? true : false
  create_account        = local.create_more_resources && var.create_account
  create_database       = local.create_more_resources && var.create_database
  create_backup_policy  = local.create_more_resources && var.create_backup_policy
  project               = "acs_rds_dashboard"
}
module "databases" {
  source                  = "./modules/database"
  profile                 = var.profile
  shared_credentials_file = var.shared_credentials_file
  region                  = var.region
  skip_region_validation  = var.skip_region_validation
  create_database         = local.create_database
  create_account          = local.create_account
  db_instance_id          = local.this_instance_id
  account_password        = var.account_password
  account_type            = var.account_type
  account_name            = var.account_name
  account_privilege       = var.account_privilege
  databases               = var.databases
}

resource "alicloud_db_instance" "this" {
  count                = var.existing_instance_id != "" ? 0 : var.create_instance ? 1 : 0
  engine               = local.engine
  engine_version       = var.engine_version
  instance_type        = var.instance_type
  instance_storage     = var.instance_storage
  instance_charge_type = var.instance_charge_type
  instance_name        = var.instance_name
  period               = var.period
  security_ips         = length(var.security_ips) > 0 ? var.security_ips : null
  vswitch_id           = var.vswitch_id
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
  count                       = local.create_backup_policy ? 1 : 0
  instance_id                 = local.this_instance_id
  backup_retention_period     = var.log_backup_retention_period
  preferred_backup_time       = var.preferred_backup_time
  preferred_backup_period     = var.preferred_backup_period
  log_backup_retention_period = var.log_backup_retention_period
  enable_backup_log           = var.enable_backup_log
}

resource "alicloud_db_connection" "db_connection" {
  count             = local.create_more_resources && var.allocate_public_connection && var.connection_prefix != "" ? 1 : 0
  instance_id       = local.this_instance_id
  connection_prefix = var.connection_prefix
  port              = var.port
}

resource "alicloud_cms_alarm" "cpu_usage" {
  count   = local.create_more_resources && var.enable_alarm_rule ? 1 : 0
  enabled = var.enable_alarm_rule
  name    = var.alarm_rule_name
  project = local.project
  metric  = "CpuUsage"
  dimensions = {
    instanceId = local.this_instance_id
    device     = "/dev/vda1,/dev/vdb1"
  }
  statistics         = var.alarm_rule_statistics
  period             = var.alarm_rule_period
  operator           = var.alarm_rule_operator
  threshold          = var.alarm_rule_threshold
  triggered_count    = var.alarm_rule_triggered_count
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
}

resource "alicloud_cms_alarm" "connection_usage" {
  count   = local.create_more_resources && var.enable_alarm_rule ? 1 : 0
  enabled = var.enable_alarm_rule
  name    = var.alarm_rule_name
  project = local.project
  metric  = "ConnectionUsage"
  dimensions = {
    instanceId = local.this_instance_id
    device     = "/dev/vda1,/dev/vdb1"
  }
  statistics         = var.alarm_rule_statistics
  period             = var.alarm_rule_period
  operator           = var.alarm_rule_operator
  threshold          = var.alarm_rule_threshold
  triggered_count    = var.alarm_rule_triggered_count
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
}
resource "alicloud_cms_alarm" "disk_usage" {
  count   = local.create_more_resources && var.enable_alarm_rule ? 1 : 0
  enabled = var.enable_alarm_rule
  name    = var.alarm_rule_name
  project = local.project
  metric  = "DiskUsage"
  dimensions = {
    instanceId = local.this_instance_id
    device     = "/dev/vda1,/dev/vdb1"
  }
  statistics         = var.alarm_rule_statistics
  period             = var.alarm_rule_period
  operator           = var.alarm_rule_operator
  threshold          = var.alarm_rule_threshold
  triggered_count    = var.alarm_rule_triggered_count
  contact_groups     = var.alarm_rule_contact_groups
  silence_time       = var.alarm_rule_silence_time
  effective_interval = var.alarm_rule_effective_interval
}

