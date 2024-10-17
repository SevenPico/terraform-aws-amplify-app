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
##  ./iam.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------

#------------------------------------------------------------------------------
# Context
#------------------------------------------------------------------------------
module "iam_context" {
  source     = "SevenPico/context/null"
  version    = "2.0.0"
  context    = module.context.self
  attributes = ["role"]
  enabled    = module.context.enabled && var.enable_iam_service_role
}


#------------------------------------------------------------------------------
# IAM
#------------------------------------------------------------------------------
module "iam_role" {
  source     = "registry.terraform.io/SevenPicoForks/iam-role/aws"
  version    = "2.0.0"
  context    = module.iam_context.self
  attributes = ["role"]

  assume_role_actions = ["sts:AssumeRole"]
  principals = {
    "Service" : ["amplify.amazonaws.com"]
  }
  assume_role_conditions   = []
  instance_profile_enabled = false
  managed_policy_arns      = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  max_session_duration     = 3600
  path                     = "/"
  permissions_boundary     = ""
  policy_description       = ""
  policy_document_count    = 1
  policy_documents         = var.additional_policy_documents

  role_description = "The role allows AWS Amplify to assume permissions for managing AWS resources required for deployment and execution of applications."
  use_fullname     = true
}

