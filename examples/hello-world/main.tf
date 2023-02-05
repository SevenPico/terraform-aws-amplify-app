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
##  ./examples/complete/main.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------

module "amplify" {
  source  = "../.."
  context = module.context.self

  basic_auth_password                       = "admin"
  basic_auth_username                       = "admin"
  branch_configuration = {
    master = {
      basic_auth              = false
      create_webhook          = true
      enable_environment      = false
      enable_performance_mode = true
      enable_preview          = false
      environment_variables   = {}
      framework               = null
      enable_basic_auth       = false
      stage                   = "PRODUCTION"
      domain_name_prefix      = "www"
    }
    develop = {
      basic_auth              = false
      create_webhook          = true
      enable_environment      = false
      enable_performance_mode = false
      enable_preview          = true
      enable_basic_auth       = false
      environment_variables   = {}
      framework               = null
      stage                   = "DEVELOPMENT"
      domain_name_prefix      = "www-develop"
    }
  }
  build_spec                                = var.build_spec
  custom_rules                              = [
    {
      source    = "</^[^.]+$|\\.(?!(css|gif|ico|jpg|js|png|txt|svg|woff|ttf|map|json)$)([^.]+$)/>"
      target    = "/"
      status    = "200"
      condition = null
    }
  ]
  auto_branch_creation_patterns             = ["*", "*/**"]
  description                               = "Hello World Application"
  enable_auto_branch_creation               = true
  enable_basic_auth                         = false
  enable_iam_service_role                   = true
  environment_variables                     = {}
  github_access_token                       = var.github_access_token
  github_organization                       = var.github_organization
  github_repo                               = var.github_repo
}
