#############
# Alarm Rule
#############
output "this_alarm_rule_effective_interval" {
  description = "The interval of effecting alarm rule."
  value       = module.postgres.this_alarm_rule_effective_interval
}

output "this_alarm_rule_id" {
  description = "The ID of the alarm rule."
  value       = module.postgres.this_alarm_rule_id
}

output "this_alarm_rule_name" {
  description = "The alarm name."
  value       = module.postgres.this_alarm_rule_name
}

output "this_alarm_rule_project" {
  description = "Monitor project name."
  value       = module.postgres.this_alarm_rule_project
}

output "this_alarm_rule_metric" {
  description = "Name of the monitoring metrics."
  value       = module.postgres.this_alarm_rule_metric
}

output "this_alarm_rule_dimensions" {
  description = "Map of the resources associated with the alarm rule."
  value       = module.postgres.this_alarm_rule_dimensions
}

output "this_alarm_rule_period" {
  description = "Index query cycle."
  value       = module.postgres.this_alarm_rule_period
}

output "this_alarm_rule_statistics" {
  description = "Statistical method."
  value       = module.postgres.this_alarm_rule_statistics
}

output "this_alarm_rule_operator" {
  description = "Alarm comparison operator."
  value       = module.postgres.this_alarm_rule_operator
}

output "this_alarm_rule_threshold" {
  description = "Alarm threshold value."
  value       = module.postgres.this_alarm_rule_threshold
}

output "this_alarm_rule_triggered_count" {
  description = "Number of trigger alarm."
  value       = module.postgres.this_alarm_rule_triggered_count
}

output "this_alarm_rule_contact_groups" {
  description = "List contact groups of the alarm rule."
  value       = module.postgres.this_alarm_rule_contact_groups
}

output "this_alarm_rule_silence_time" {
  description = " Notification silence period in the alarm state."
  value       = module.postgres.this_alarm_rule_silence_time
}

output "this_alarm_rule_notify_type" {
  description = "Notification type."
  value       = module.postgres.this_alarm_rule_notify_type
}

output "this_alarm_rule_enabled" {
  description = "Whether to enable alarm rule."
  value       = module.postgres.this_alarm_rule_enabled
}

output "this_alarm_rule_cpu_usage_status" {
  description = "The current alarm cpu usage rule status."
  value       = module.postgres.this_alarm_rule_cpu_usage_status
}

output "this_alarm_rule_disk_usage_status" {
  description = "The current alarm disk usage rule status."
  value       = module.postgres.this_alarm_rule_disk_usage_status
}

output "this_alarm_rule_connection_usage_status" {
  description = "The current alarm memory usage rule status."
  value       = module.postgres.this_alarm_rule_connection_usage_status
}

#######################
# Postgre SQL Instance
#######################

output "this_db_instance_id" {
  description = "Postgre SQL instance id."
  value       = module.postgres.this_db_instance_id
}

output "this_db_instance_engine" {
  description = "Postgre SQL instance engine."
  value       = module.postgres.this_db_instance_engine
}

output "this_db_instance_engine_version" {
  description = "Postgre SQL instance engine version."
  value       = module.postgres.this_db_instance_engine_version
}

output "this_db_instance_type" {
  description = "Postgre SQL instance type."
  value       = module.postgres.this_db_instance_type
}

output "this_db_instance_storage" {
  description = "Postgre SQL instance storage."
  value       = module.postgres.this_db_instance_storage
}

output "this_db_instance_charge_type" {
  description = "Postgre SQL instance charge type."
  value       = module.postgres.this_db_instance_charge_type
}

output "this_db_instance_name" {
  description = "Postgre SQL instance name."
  value       = module.postgres.this_db_instance_name
}

output "this_db_instance_security_ips" {
  description = "Postgre SQL instance security ip list."
  value       = module.postgres.this_db_instance_security_ips
}

output "this_db_instance_zone_id" {
  description = "The zone id in which the postgres instance."
  value       = module.postgres.this_db_instance_zone_id
}

output "this_db_instance_vswitch_id" {
  description = "The vswitch id in which the postgres instance."
  value       = module.postgres.this_db_instance_vswitch_id
}

output "this_db_instance_security_group_ids" {
  description = "The security group ids in which the postgres instance."
  value       = module.postgres.this_db_instance_security_group_ids
}

output "this_db_instance_tags" {
  description = "Postgre SQL instance tags"
  value       = module.postgres.this_db_instance_tags
}

##################################
# Postgre SQL instance Connection
##################################

output "this_db_instance_connection_string" {
  description = "Postgre SQL instance public connection string."
  value       = module.postgres.this_db_instance_connection_string
}

output "this_db_instance_port" {
  description = "Postgre SQL instance connection port."
  value       = module.postgres.this_db_instance_port
}

output "this_db_instance_connection_ip_address" {
  description = "Postgre SQL instance public connection string's ip address."
  value       = module.postgres.this_db_instance_connection_ip_address
}

#######################
# Postgre SQL Database
#######################

output "this_db_database_description" {
  description = "Postgre SQL database description."
  value       = module.postgres.this_db_database_description
}

output "this_db_database_id" {
  description = "Postgre SQL database id."
  value       = module.postgres.this_db_database_id
}

output "this_db_database_name" {
  description = "Postgre SQL database name."
  value       = module.postgres.this_db_database_name
}

###############################
# Postgre SQL Database Account
###############################

output "this_db_database_account" {
  description = "Postgre SQL database account."
  value       = module.postgres.this_db_database_account
}

output "this_db_database_account_privilege" {
  description = "Postgre SQL database account privilege."
  value       = module.postgres.this_db_database_account_privilege
}

output "this_db_database_account_type" {
  description = "Postgre SQL database account type."
  value       = module.postgres.this_db_database_account_type
}
