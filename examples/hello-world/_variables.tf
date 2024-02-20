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
##  ./examples/complete/_variables.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------

variable "root_domain" {
  default = "7pi.io"
}

variable "github_access_token" {
  type = string
}

variable "github_organization" {
  type = string
}

variable "github_repo" {
  type = string
}

variable "environment_variables" {
  default = {
    "_BUILD_TIMEOUT" = "30"
    "_CUSTOM_IMAGE"  = "awsamplifyconsole/build-web:1"
  }
}

variable "build_spec" {
  default = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - yarn install
            - mkdir -p dist
        build:
          commands:
            - yarn run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT
}
