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
##  ./variables.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------

variable "github_organization" {
  type        = string
  description = "The GitHub organization or user where the repo lives."
}

variable "github_repo" {
  type        = string
  description = "The name of the repo that the Amplify App will be created around."
}

variable "enable_iam_service_role" {
  default     = false
  type        = bool
  description = "(Optional) AWS Identity and Access Management (IAM) service role for an Amplify app."
}

variable "branch_configuration" {
  default = {
    master = {
      basic_auth                  = false
      create_webhook              = true
      enable_environment          = false
      enable_performance_mode     = true
      enable_preview              = false
      enable_pull_request_preview = false
      environment_variables       = {}
      framework                   = null
      enable_basic_auth           = false
      stage                       = "PRODUCTION"
      domain_name_prefix          = "www"
    }
    develop = {
      basic_auth                  = false
      create_webhook              = true
      enable_environment          = false
      enable_performance_mode     = false
      enable_preview              = true
      enable_pull_request_preview = false
      enable_basic_auth           = false
      environment_variables       = {}
      framework                   = null
      stage                       = "DEVELOPMENT"
      domain_name_prefix          = "www-develop"
    }
  }
  type = map(object({
    basic_auth                  = bool
    create_webhook              = bool
    enable_environment          = bool # Required
    enable_performance_mode     = bool
    enable_preview              = bool
    enable_pull_request_preview = bool
    enable_basic_auth           = bool
    environment_variables       = map(string)
    framework                   = any    # String - can be null
    stage                       = string # PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST
    domain_name_prefix          = string
  }))
  description = "(Optional) Specify Branches to Monitor and Configure."
}


variable "environment_variables" {
  default     = {}
  type        = map(string)
  description = "(Optional) Environment variables map for an Amplify app."
}


variable "auto_branch_creation_patterns" {
  default     = ["*", "*/**"]
  type        = list(string)
  description = "(Optional) Automated branch creation glob patterns for an Amplify app."
}

variable "auto_branch_stage" {
  default     = "PULL_REQUEST"
  type        = string
  description = "(Optional) Describes the current stage for the autocreated branch. Valid values: PRODUCTION, BETA, DEVELOPMENT, EXPERIMENTAL, PULL_REQUEST."
}

variable "enable_auto_branch_creation" {
  default     = false
  type        = bool
  description = "(Optional) Enables automated branch creation for an Amplify app."
}

variable "github_access_token" {
  type        = string
  description = "(Optional) Personal access token for a third-party source control system for an Amplify app. The personal access token is used to create a webhook and a read-only deploy key. The token is not stored."
}

variable "description" {
  type        = string
  description = " (Optional) Description for an Amplify app."
  default     = null
}

variable "build_spec" {
  default     = ""
  type        = string
  description = "(Optional) The build specification (build spec) for an Amplify app."
}

variable "enable_basic_auth" {
  default     = false
  type        = bool
  description = " (Optional) Enable basic authorization for an Amplify app."
}

variable "basic_auth_username" {
  type        = string
  description = "(Optional) Credentials for basic authorization for an Amplify app."
}

variable "basic_auth_password" {
  type        = string
  description = "(Optional) Credentials for basic authorization for an Amplify app."
}


variable "custom_rules" {
  default = []
  type = list(object({
    source    = string # Required
    target    = string # Required
    status    = any    # Can be null
    condition = any    # Can be null
  }))
  description = "(Optional) Custom rewrite and redirect rules for an Amplify app. A custom_rule block is documented below."
}

variable "additional_domain_names" {
  type        = set(string)
  default     = []
  description = "(Optional) A list of domain names that should be added to the domain configuration for the Amplify App."
}

variable "platform" {
  type    = string
  default = "WEB"

  description = "(Optional) Platform or framework for an Amplify app. Valid values: WEB, WEB_COMPUTE. Default value: WEB"

  validation {
    condition     = var.platform == "WEB" || var.platform == "WEB_COMPUTE"
    error_message = "The platform variable must be either 'WEB' or 'WEB_COMPUTE'."
  }
}

variable "additional_policy_documents" {
  type        = list(string)
  default     = []
  description = "(Optional) A list of policy documents for the Amplify App role."
}

