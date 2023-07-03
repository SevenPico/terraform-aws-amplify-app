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
data "aws_iam_policy_document" "amplify_assume_role" {
  count = module.iam_context.enabled ? 1 : 0
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  #checkov:skip=CKV_AWS_274:skipping 'Disallow IAM roles, users, and groups from using the AWS AdministratorAccess policy'
  count = module.iam_context.enabled ? 1 : 0

  assume_role_policy  = join("", data.aws_iam_policy_document.amplify_assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  name                = module.iam_context.id
  tags                = module.iam_context.tags
}

