include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/rds/parameter_group?ref=v0.1.56-rds"
}

locals {

  psql_basic_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "rds.logical_replication"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_connections"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_disconnections"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_lock_waits"
      value        = "1"
    },
    {
      apply_method = "immediate"
      name         = "log_min_duration_statement"
      value        = "2000"
    },
    {
      apply_method = "immediate"
      name         = "log_statement"
      value        = "ddl"
    },
    {
      apply_method = "immediate"
      name         = "log_temp_files"
      value        = "4096"
    },
    {
      apply_method = "immediate"
      name         = "checkpoint_timeout"
      value        = "1800"
    },
    {
      apply_method = "immediate"
      name         = "min_wal_size"
      value        = "5000"
    },
    {
      apply_method = "immediate"
      name         = "max_wal_size"
      value        = "10000"
    }
  ]

  psql_extra_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "shared_buffers"
      value        = "{DBInstanceClassMemory/24576}"
    },
    {
      apply_method = "pending-reboot"
      name         = "max_connections"
      value        = "LEAST({DBInstanceClassMemory/19062784},2500)"
    }
  ]

  psql_legacy_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements"
    }
  ]

  psql_modern_parameters = [
    {
      apply_method = "pending-reboot"
      name         = "shared_preload_libraries"
      value        = "pg_stat_statements,pg_cron"
    }
  ]

}

inputs = {

  parameter_groups = {

     mysql-dms = {
       name        = "mysql-dms"
       family      = "mysql8.0"
       description = "MySQL for DMS"
       parameters  = [
         {
           name  = "binlog_format"
           value = "ROW"
         },
         {
           name  = "binlog_checksum"
           value = "NONE"
         }
       ]
       tags = { App = "studio" }
     }

     psql_11 = {
       name            = "pm-postgres11-common"
       description     = "Paramter group for PostgresSQL 11 version"
       family          = "postgres11"
       parameters      = concat(local.psql_basic_parameters, local.psql_extra_parameters, local.psql_legacy_parameters)
     }

     psql_12 = {
       name            = "pm-postgres12-common"
       description     = "Paramter group for PostgresSQL 12 version"
       family          = "postgres12"
       parameters      = concat(local.psql_basic_parameters, local.psql_extra_parameters, local.psql_legacy_parameters)
     }

     psql_13 = {
       name            = "pm-postgres13-common"
       description     = "Paramter group for PostgresSQL 13 version"
       family          = "postgres13"
       parameters      = concat(local.psql_basic_parameters, local.psql_extra_parameters, local.psql_legacy_parameters)
     }

     psql_14 = {
       name            = "pm-postgres14-common"
       description     = "Paramter group for PostgresSQL 14 version"
       family          = "postgres14"
       parameters      = concat(local.psql_basic_parameters, local.psql_extra_parameters, local.psql_legacy_parameters)
     }

     psql_15 = {
       name            = "pm-postgres15-common"
       description     = "Paramter group for PostgresSQL 15 version"
       family          = "postgres15"
       parameters      = concat(local.psql_basic_parameters, local.psql_extra_parameters, local.psql_legacy_parameters)
     }

     psql_11c = {
       name            = "pm-postgres11-crowd"
       description     = "Paramter group for PostgresSQL 11 version"
       family          = "postgres11"
       parameters      = concat(local.psql_basic_parameters, local.psql_legacy_parameters)
     }

     psql_12c = {
       name            = "pm-postgres12-crowd"
       description     = "Paramter group for PostgresSQL 12 version"
       family          = "postgres12"
       parameters      = concat(local.psql_basic_parameters, local.psql_modern_parameters)
     }

     psql_13c = {
       name            = "pm-postgres13-crowd"
       description     = "Paramter group for PostgresSQL 13 version"
       family          = "postgres13"
       parameters      = concat(local.psql_basic_parameters, local.psql_modern_parameters)
     }

     psql_14c = {
       name            = "pm-postgres14-crowd"
       description     = "Paramter group for PostgresSQL 14 version"
       family          = "postgres14"
       parameters      = concat(local.psql_basic_parameters, local.psql_modern_parameters)
     }

     psql_15c = {
       name            = "pm-postgres15-crowd"
       description     = "Paramter group for PostgresSQL 15 version"
       family          = "postgres15"
       parameters      = concat(local.psql_basic_parameters, local.psql_modern_parameters)
     }
  }
}
