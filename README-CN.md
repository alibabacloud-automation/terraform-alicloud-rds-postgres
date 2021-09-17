terraform-alicloud-rds-postgres
-------

本 Module 用于在阿里云的 VPC 下创建一个[Postgre SQL 云数据库](https://help.aliyun.com/document_detail/26092.html)，并为其配置云监控。

本 Module 支持创建以下资源:

* [Postgre SQL 数据库实例 (db_instance)](https://www.terraform.io/docs/providers/alicloud/r/db_instance.html)
* [Account 数据库用户实例 (db_account)](https://www.terraform.io/docs/providers/alicloud/r/db_account.html)
* [Database 数据库实例 (db_database)](https://www.terraform.io/docs/providers/alicloud/r/db_database.html)
* [BackupPolicy 备份实例 (db_backup_policy)](https://www.terraform.io/docs/providers/alicloud/r/db_backup_policy.html)
* [CmsAlarm 云监控实例 (cms_alarm)](https://www.terraform.io/docs/providers/alicloud/r/cms_alarm.html)


## Terraform 版本

本模板要求使用版本 Terraform 0.12 和阿里云 Provider 1.71.0+。

## 用法

#### 创建新的Rds实例

```hcl
module "postgres" {
  source = "terraform-alicloud-modules/rds-postgres/alicloud"
  region = "cn-hangzhou"

  #################
  # Rds Instance
  #################
  engine_version       = "10.0"
  instance_storage     = 20
  instance_charge_type = "Postpaid"
  vswitch_id           = "vsw-bp1tili2u5kxxxxxx"
  instance_name        = "PostgreSQLInstance"
  instance_type        = "rds.pg.s1.small"
  security_group_ids   = ["sg-2ze7v4p5skehxxxxxxxx"]
  security_ips         = ["11.193.xx.xx/24", "101.37.xx.xx/24"]
  tags = {
    Env      = "Private"
    Location = "Secret"
  }

  ####################
  # Rds Backup policy
  ####################
  preferred_backup_period     = ["Monday", "Wednesday"]
  preferred_backup_time       = "00:00Z-01:00Z"
  backup_retention_period     = 7
  log_backup_retention_period = 7
  enable_backup_log           = true
  allocate_public_connection  = false

  ###########
  #databases
  ###########
  privilege = "DBOwner"
  databases = [
    {
      name          = "dbuser1"
      character_set = "UTF8"
      description   = "db1"
    },
    {
      name          = "dbuser2"
      character_set = "UTF8"
      description   = "db2"
    },
  ]

  #######################
  # Rds Database account
  #######################
  account_privilege     = "DBOwner"
  account_name          = "account_name1"
  account_password      = "yourpassword123"

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
```

### 使用已经存在的Rds实例

```hcl
module "postgres" {
  source = "terraform-alicloud-modules/rds-postgres/alicloud"
  region = "cn-beijing"

  #################
  # Rds Instance
  #################
  existing_instance_id = "pgm-2zehbutrxxxxxx"

  #################
  # Rds Backup policy
  #################
  create_backup_policy=true
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
      name          = "postgre_sqldb"
      character_set = "UTF8"
      description   = "db1"
    }
  ]

  #######################
  # Rds Database Account
  #######################
  account_privilege = "DBOwner"
  account_name      = "account_name"
  account_password  = "yourpassword123"
  tags = {
    Env      = "Private"
    Location = "Secret"
  }

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
```

## 示例

* [创建 Postgres 完整示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/examples/complete)
* [使用已经存在的 Rds 实例创建 Postgres 示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/examples/using-existing-rds-instance)

## 模块

* [database 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/database)
* [postgres-10-basic 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-10-basic)
* [postgres-10-high-availability 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-10-high-availability)
* [postgres-11-basic 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-11-basic)
* [postgres-11-high-availability 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-11-high-availability)
* [postgres-12-basic 模块](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-12-basic)

## 注意事项

* 本 Module 使用的 AccessKey 和 SecretKey 可以直接从 `profile` 和 `shared_credentials_file` 中获取。如果未设置，可通过下载安装 [aliyun-cli](https://github.com/aliyun/aliyun-cli#installation) 后进行配置。


提交问题
------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

许可
----
Apache 2 Licensed. See LICENSE for full details.

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)


