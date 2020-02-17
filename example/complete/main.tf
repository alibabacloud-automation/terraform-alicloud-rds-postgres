variable "region" {
  default = "cn-beijing"
}

provider "alicloud" {
  region = var.region
}

data "alicloud_vpcs" "default" {
  is_default = true
}
data "alicloud_zones" "default" {
  available_resource_creation = "Rds"
  multi                       = true
  enable_details              = true
}
resource "alicloud_vswitch" "this" {
  name              = "postgres_vpc"
  availability_zone = data.alicloud_zones.default.zones.0.multi_zone_ids.0
  vpc_id            = data.alicloud_vpcs.default.vpcs.0.id
  cidr_block        = cidrsubnet(data.alicloud_vpcs.default.vpcs.0.cidr_block, 4, 15)
}
module "security_group" {
  source = "alibaba/security-group/alicloud"
  region = var.region
  vpc_id = data.alicloud_vpcs.default.ids.0
}
locals {
  engine         = "PostgreSQL"
  engine_version = "10.0"
}
data "alicloud_db_instance_classes" "default" {
  engine         = local.engine
  engine_version = local.engine_version
  category       = "Basic"
  storage_type   = "cloud_ssd"
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
  vswitch_id           = alicloud_vswitch.this.id
  instance_name        = "PostgreSQLInstance"
  instance_storage     = lookup(data.alicloud_db_instance_classes.default.instance_classes.0.storage_range, "min")
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
  account_password  = "yourpassword123"

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