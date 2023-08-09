variable "region" {
  default = "cn-beijing"
}
provider "alicloud" {
  region = var.region
}
locals {
  engine                   = "PostgreSQL"
  engine_version           = "12.0"
  category                 = "Basic"
  db_instance_storage_type = "cloud_essd"
  instance_charge_type     = "PostPaid"
}

data "alicloud_db_zones" "default" {
  engine                   = local.engine
  engine_version           = local.engine_version
  instance_charge_type     = local.instance_charge_type
  category                 = local.category
  db_instance_storage_type = local.db_instance_storage_type
}

resource "alicloud_vpc" "default" {
  vpc_name   = "terraform-example"
  cidr_block = "10.4.0.0/16"
}

resource "alicloud_vswitch" "default" {
  vswitch_name = "terraform-example"
  cidr_block   = "10.4.0.0/24"
  vpc_id       = alicloud_vpc.default.id
  zone_id      = data.alicloud_db_zones.default.zones.0.id
}
module "security_group" {
  source = "alibaba/security-group/alicloud"
  region = var.region
  vpc_id = alicloud_vpc.default.id
}

data "alicloud_db_instance_classes" "default" {
  zone_id                  = data.alicloud_db_zones.default.zones.0.id
  engine                   = local.engine
  engine_version           = local.engine_version
  category                 = local.category
  db_instance_storage_type = local.db_instance_storage_type
  instance_charge_type     = local.instance_charge_type
}
module "postgres" {
  source = "../../"
  region = var.region

  #################
  # Rds Instance
  #################
  create_instance      = true
  engine_version       = local.engine_version
  instance_type        = data.alicloud_db_instance_classes.default.instance_classes.0.instance_class
  vswitch_id           = alicloud_vswitch.default.id
  instance_name        = "PostgreSQLInstance"
  instance_storage     = data.alicloud_db_instance_classes.default.instance_classes.0.storage_range.min
  instance_charge_type = "Postpaid"
  security_group_ids   = [module.security_group.this_security_group_id]
  security_ips         = ["11.193.54.0/24", "101.37.74.0/24", ]
  tags = {
    Env      = "Private"
    Location = "Secret"
  }

  #################
  # Rds Backup policy
  #################
  preferred_backup_period     = ["Monday", "Wednesday"]
  preferred_backup_time       = "00:00Z-01:00Z"
  backup_retention_period     = 7
  log_backup_retention_period = 7
  enable_backup_log           = true
  allocate_public_connection  = false

  ###########
  #databases
  ###########
  databases = [
    {
      name          = "postgre_sql"
      character_set = "UTF8"
      description   = "db1"
    }
  ]

  #######################
  # Rds Database Account
  #######################
  account_privilege = "DBOwner"
  account_name      = "account_name1"
  account_password  = "Example12345"

  #############
  # Alarm Rule
  #############
  alarm_rule_name            = "CmsAlarmForPostgreSQL"
  alarm_rule_statistics      = "Average"
  alarm_rule_period          = 300
  alarm_rule_operator        = "<="
  alarm_rule_threshold       = 35
  alarm_rule_triggered_count = 2
  alarm_rule_contact_groups  = ["postgre"]
}