Terraform module which create a PostgreSQL database based on Alibaba Cloud RDS Service.  
 terraform-alicloud-rds-postgres
 ------------
 
English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/blob/master/README-CN.md)

Terraform module which creates rds-postgres database and sets CMS alarm for it on Alibaba Cloud. 

These types of resources are supported:

* [Alicloud_db_instance](https://www.terraform.io/docs/providers/alicloud/r/db_instance.html)
* [Alicloud_db_account](https://www.terraform.io/docs/providers/alicloud/r/db_account.html)
* [Alicloud_db_database](https://www.terraform.io/docs/providers/alicloud/r/db_database.html)
* [Alicloud_db_backup_policy](https://www.terraform.io/docs/providers/alicloud/r/db_backup_policy.html)
* [alicloud_cms_alarm](https://www.terraform.io/docs/providers/alicloud/r/alarm_rule.html)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.71.0 |

## Usage

For new instance

```hcl
module "postgres" {
  source = "terraform-alicloud-modules/rds-postgres/alicloud"

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

For existing instance
```hcl
module "postgres" {
  source = "terraform-alicloud-modules/rds-postgres/alicloud"

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


## Examples

* [Complete Example](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/examples/complete)
* [Using exising Rds Instance Example](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/examples/using-existing-rds-instance)

## Modules

* [database](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/database)
* [postgres-10-basic](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-10-basic)
* [postgres-10-high-availability](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-10-high-availability)
* [postgres-11-basic](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-11-basic)
* [postgres-11-high-availability](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-11-high-availability)
* [postgres-12-basic](https://github.com/terraform-alicloud-modules/terraform-alicloud-rds-postgres/tree/master/modules/postgres-12-basic)

## Notes
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
 profile                 = var.profile != "" ? var.profile : null
 shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
 region                  = var.region != "" ? var.region : null
 skip_region_validation  = var.skip_region_validation
 configuration_source    = "terraform-alicloud-modules/rds-postgres"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "rds-postgres" {
  source = "terraform-alicloud-modules/rds-postgres/alicloud"
  version     = "1.0.0"
  region      = "cn-hangzhou"
  profile     = "Your-Profile-Name"
  engine_version       = "10.0"
  instance_storage     = 20
  instance_charge_type = "Postpaid"
  vswitch_id           = "vsw-bp1tili2u5kxxxxxx"
  instance_name        = "PostgreSQLInstance"
  instance_type        = "rds.pg.s1.small"
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
   region  = "cn-hangzhou"
   profile = "Your-Profile-Name"
}
module "rds-postgres" {
 source = "terraform-alicloud-modules/rds-postgres/alicloud"
 engine_version       = "10.0"
 instance_storage     = 20
 instance_charge_type = "Postpaid"
 vswitch_id           = "vsw-bp1tili2u5kxxxxxx"
 instance_name        = "PostgreSQLInstance"
 instance_type        = "rds.pg.s1.small"
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "rds-postgres" {
 source = "terraform-alicloud-modules/rds-postgres/alicloud"
  providers = {
    alicloud = alicloud.hz
  }
 engine_version       = "10.0"
 instance_storage     = 20
 instance_charge_type = "Postpaid"
 vswitch_id           = "vsw-bp1tili2u5kxxxxxx"
 instance_name        = "PostgreSQLInstance"
 instance_type        = "rds.pg.s1.small"
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.
More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

Submit Issues
-------------
If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

License
----
Apache 2 Licensed. See LICENSE for full details.

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

