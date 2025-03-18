### TODO update tags in module
#include "root" {
#  path = find_in_parent_folders()
#}
#
#terraform {
#  source = "git::https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules.git//providers/aws/database/aurora"
#}
#
#inputs = {
#  dns_zone = "studio-stage.cloud.corp.loc"
#  name = "studio_aurora"
#  studio_aurora = {
##    studio_report_portal = {
##      name            = "studio-report-portal"
##      admin_username  = "studio_report_portal_admin"
##      admin_password  = "studio_report_portal_admin_password"
##      snake_case_name = "studio_report_portal"
##      serverlessv2_scaling_configuration = {
##        min_capacity = 1
##        max_capacity = 2
##      }
##      instance_replicas = {
##        instance-01 = {}
##      }
##      backup_retention_period = 1
##      tags = {
##        Jira = "studioSTREAM-14420"
##        Team = "QA-Automation"
##        App  = "studio-report-portal"
##      }
##    }
#  }
#}
#
#dependencies {
#  paths = [
#    "../../security/kms",
#    "../../networking/vpc",
#    "../../security/iam",
#    "../../database/common"
#  ]
#}
