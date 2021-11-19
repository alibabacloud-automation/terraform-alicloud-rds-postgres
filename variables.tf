#################
# Provider
#################

variable "region" {
  description = "(Deprecated from version 1.1.0)The region used to launch this module resources."
  type        = string
  default     = ""
}

variable "profile" {
  description = "(Deprecated from version 1.1.0)The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}

variable "shared_credentials_file" {
  description = "(Deprecated from version 1.1.0)This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.1.0)Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

#############
# Alarm Rule
#############

variable "alarm_rule_effective_interval" {
  description = "The interval of effecting alarm rule. It foramt as 'hh:mm-hh:mm', like '0:00-4:00'."
  type        = string
  default     = "0:00-2:00"
}

variable "enable_alarm_rule" {
  description = "Whether to enable alarm rule. Default to true."
  type        = bool
  default     = true
}

variable "alarm_rule_name" {
  description = "The alarm rule name."
  type        = string
  default     = ""
}

variable "alarm_rule_period" {
  description = "Index query cycle, which must be consistent with that defined for metrics. Default to 300, in seconds."
  type        = number
  default     = 300
}

variable "alarm_rule_statistics" {
  description = "Statistical method. It must be consistent with that defined for metrics. Valid values: ['Average', 'Minimum', 'Maximum']. Default to 'Average'."
  type        = string
  default     = "Average"
}

variable "alarm_rule_operator" {
  description = "Alarm comparison operator. Valid values: ['<=', '<', '>', '>=', '==', '!=']. Default to '=='."
  type        = string
  default     = "=="
}

variable "alarm_rule_threshold" {
  description = "Alarm threshold value, which must be a numeric value currently."
  type        = string
  default     = ""
}

variable "alarm_rule_triggered_count" {
  description = "Number of consecutive times it has been detected that the values exceed the threshold. Default to 3."
  type        = number
  default     = 3
}

variable "alarm_rule_contact_groups" {
  description = "List contact groups of the alarm rule, which must have been created on the console."
  type        = list(string)
  default     = []
}

variable "alarm_rule_silence_time" {
  description = "Notification silence period in the alarm state, in seconds. Valid value range: [300, 86400]. Default to 86400."
  type        = number
  default     = 86400
}

#######################
# Postgre SQL Instance
#######################

variable "existing_instance_id" {
  description = "The Id of an existing postgre sql instance. If set, the 'create_instance' will be ignored."
  type        = string
  default     = ""
}

variable "create_instance" {
  description = "Whether to create postgre sql instance. If false, you can use a existing Postgre SQL instance by setting 'existing_instance_id'."
  type        = bool
  default     = true
}

variable "engine_version" {
  description = "PostgresSQL database version. Valid values: '10', '11', '12'."
  type        = string
  default     = ""
}

variable "instance_name" {
  description = "The name of Postgre SQL Instance. A name with 'tf-module-postgres' will be set if it is empty."
  type        = string
  default     = "tf-module-postgres"
}

variable "instance_charge_type" {
  description = "The instance charge type. Valid values: Prepaid and Postpaid. Default to Postpaid."
  type        = string
  default     = "Postpaid"
}

variable "instance_storage" {
  description = "The storage capacity of the instance. Unit: GB. The storage capacity increases at increments of 5 GB. For more information, see [Instance Types](https://www.alibabacloud.com/help/doc-detail/26312.htm)."
  type        = number
  default     = 20
}

variable "instance_type" {
  description = "Postgres Instance type, for example: rds.pg.s1.small. full list is : https://www.alibabacloud.com/help/zh/doc-detail/26312.htm"
  default     = ""
}

variable "period" {
  description = "The duration that you will buy Postgres Instance (in month). It is valid when instance_charge_type is PrePaid. Valid values: [1~9], 12, 24, 36. Default to 1"
  type        = number
  default     = 1
}

variable "security_group_ids" {
  description = "List of VPC security group ids to associate with postgre sql instance."
  type        = list(string)
  default     = []
}

variable "vswitch_id" {
  description = "The virtual switch ID to launch Postgre SQL Instances in one VPC."
  type        = string
  default     = ""
}

variable "security_ips" {
  description = " List of IP addresses allowed to access all databases of an instance. The list contains up to 1,000 IP addresses, separated by commas. Supported formats include 0.0.0.0/0, 10.23.12.24 (IP), and 10.23.12.24/24 (Classless Inter-Domain Routing (CIDR) mode. /24 represents the length of the prefix in an IP address. The range of the prefix length is [1,32])."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A mapping of tags to assign to the postgre sql."
  type        = map(string)
  default     = {}
}

############################
# Postgre SQL Backup policy
############################
variable "create_backup_policy" {
  description = "Whether to create Postgre SQL instance's backup policy."
  type        = bool
  default     = true
}

variable "preferred_backup_period" {
  description = "Postgre SQL Instance backup period."
  type        = list(string)
  default     = []
}

variable "preferred_backup_time" {
  description = " Postgre SQL Instance backup time, in the format of HH:mmZ- HH:mmZ."
  type        = string
  default     = "02:00Z-03:00Z"
}

variable "backup_retention_period" {
  description = "Instance backup retention days. Valid values: [7-730]. Default to 7."
  type        = number
  default     = 7
}

variable "enable_backup_log" {
  description = "Whether to backup instance log. Default to true."
  type        = bool
  default     = false
}

variable "log_backup_retention_period" {
  description = "Instance log backup retention days. Valid values: [7-730]. Default to 7. It can be larger than 'retention_period'."
  type        = number
  default     = 7
}

#########################
# Postgre SQL Connection
#########################

variable "allocate_public_connection" {
  description = "Whether to allocate public connection for a Postgre SQL instance. If true, the connection_prefix can not be empty."
  type        = bool
  default     = false
}

variable "connection_prefix" {
  description = "Prefix of an Internet connection string. It must be checked for uniqueness. It may consist of lowercase letters, numbers, and underlines, and must start with a letter and have no more than 30 characters."
  type        = string
  default     = ""
}

variable "port" {
  description = " Internet connection port. Valid value: [3001-3999]. Default to 3306."
  type        = number
  default     = 3306
}

#######################
# Postgre SQL Database
#######################

variable "create_database" {
  description = "Whether to create multiple databases. If true, the 'databases' should not be empty."
  type        = bool
  default     = true
}

variable "databases" {
  description = "A list mapping used to add multiple databases. Each item supports keys: name, character_set and description. It should be set when create_database = true."
  type        = list(map(string))
  default     = []
}
###############################
# Postgre SQL Database Account
###############################
variable "create_account" {
  description = "Whether to create a new account. If true, the 'account_name' should not be empty."
  type        = bool
  default     = true
}

variable "account_name" {
  description = "Name of a new database account. It should be set when create_account = true."
  type        = string
  default     = ""
}

variable "account_password" {
  description = "Operation database account password. It may consist of letters, digits, or underlines, with a length of 6 to 32 characters."
  type        = string
  default     = ""
}

variable "account_type" {
  description = "Privilege type of account. Normal: Common privilege. Super: High privilege.Default to Normal."
  type        = string
  default     = "Normal"
}

variable "account_privilege" {
  description = "The privilege of one account access database."
  type        = string
  default     = "DBOwner"
}


