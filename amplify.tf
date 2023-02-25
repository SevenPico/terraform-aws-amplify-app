## ----------------------------------------------------------------------------
##  Copyright 2023 SevenPico, Inc.
##
##  Licensed under the Apache License, Version 2.0 (the "License");
##  you may not use this file except in compliance with the License.
##  You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
##  Unless required by applicable law or agreed to in writing, software
##  distributed under the License is distributed on an "AS IS" BASIS,
##  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
##  See the License for the specific language governing permissions and
##  limitations under the License.
## ----------------------------------------------------------------------------

## ----------------------------------------------------------------------------
##  ./main.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Locals
#------------------------------------------------------------------------------
locals {
  basic_auth_creds = try(base64encode("${var.basic_auth_username}:${var.basic_auth_password}"), null)
}


#------------------------------------------------------------------------------
# Context
#------------------------------------------------------------------------------
module "branch_context" {
  for_each = module.context.enabled ? var.branch_configuration : {}

  source     = "SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  attributes = [each.key]
}


#------------------------------------------------------------------------------
# Amplify Application
#------------------------------------------------------------------------------
resource "aws_amplify_app" "default" {
  count = module.context.enabled ? 1 : 0

  access_token                = var.github_access_token
  basic_auth_credentials      = local.basic_auth_creds
  build_spec                  = var.build_spec != "" ? var.build_spec : null
  description                 = var.description != null ? var.description : "Amplify App for the github.com/${var.github_organization}/${var.github_repo} project."
  enable_basic_auth           = var.enable_basic_auth
  enable_branch_auto_build    = true
  enable_auto_branch_creation = var.enable_auto_branch_creation
  enable_branch_auto_deletion = var.enable_auto_branch_creation
  environment_variables       = var.environment_variables
  iam_service_role_arn        = var.enable_iam_service_role ? aws_iam_role.default[0].arn : null
  name                        = module.context.id
  repository                  = "https://github.com/${var.github_organization}/${var.github_repo}"
  tags                        = module.context.tags
  platform                    = "WEB"

  auto_branch_creation_patterns = var.auto_branch_creation_patterns
  auto_branch_creation_config {
    basic_auth_credentials      = local.basic_auth_creds
    build_spec                  = var.build_spec
    enable_basic_auth           = var.enable_basic_auth
    enable_auto_build           = true
    enable_performance_mode     = false
    enable_pull_request_preview = true
    environment_variables       = var.environment_variables
    #    framework                     = ""
    #    pull_request_environment_name = ""
    stage = var.auto_branch_stage
  }

  dynamic "custom_rule" {
    for_each = var.custom_rules
    iterator = rule
    content {
      source    = rule.value.source
      target    = rule.value.target
      status    = rule.value.status
      condition = lookup(rule.value, "condition", null)
    }
  }

}


#------------------------------------------------------------------------------
# Amplify Deployment Branches and Associations
#------------------------------------------------------------------------------
locals {
  backends = { for name, branch in var.branch_configuration : name => name if branch.enable_environment }
  webhooks = { for name, branch in var.branch_configuration : name => name if branch.create_webhook }
}
resource "aws_amplify_backend_environment" "default" {
  for_each = module.context.enabled ? local.backends : {}

  app_id           = aws_amplify_app.default[0].id
  environment_name = each.key
}

resource "aws_amplify_branch" "default" {
  for_each = module.context.enabled ? var.branch_configuration : {}

  app_id                  = aws_amplify_app.default[0].id
  backend_environment_arn = each.value.enable_environment ? aws_amplify_backend_environment.default[each.key].arn : null
  basic_auth_credentials  = local.basic_auth_creds
  branch_name             = each.key
  display_name            = module.branch_context[each.key].id
  enable_pull_request_preview = each.value.enable_pull_request_preview
  enable_basic_auth       = each.value.enable_basic_auth
  environment_variables   = each.value.environment_variables
  tags                    = module.branch_context[each.key].tags
  stage                   = each.value.stage
  enable_performance_mode = each.value.enable_performance_mode
  framework               = each.value.framework

  lifecycle {
    ignore_changes = [framework]
  }
}


#------------------------------------------------------------------------------
# Amplify Domain Name Association
#------------------------------------------------------------------------------
resource "aws_amplify_domain_association" "default" {
  count = module.context.domain_name != "" && module.context.enabled ? 1 : 0

  app_id                = aws_amplify_app.default[0].id
  domain_name           = module.context.domain_name
  wait_for_verification = false

  dynamic "sub_domain" {
    for_each = var.branch_configuration
    iterator = branch
    content {
      branch_name = aws_amplify_branch.default[branch.key].branch_name
      prefix      = branch.value.domain_name_prefix
    }
  }
}


#------------------------------------------------------------------------------
# Amplify Webhooks
#------------------------------------------------------------------------------
resource "aws_amplify_webhook" "default" {
  for_each = module.context.enabled ? local.webhooks : {}

  app_id      = aws_amplify_app.default[0].id
  branch_name = aws_amplify_branch.default[each.key].branch_name
  description = "trigger-${each.key}"
}

resource "null_resource" "default" {
  for_each   = module.context.enabled ? local.webhooks : {}
  depends_on = [aws_amplify_webhook.default]
  provisioner "local-exec" {
    command = "curl -X POST -d {} '${aws_amplify_webhook.default[each.key].url}&operation=startbuild' -H 'Content-Type:application/json'"
  }
}


