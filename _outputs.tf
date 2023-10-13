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
##  ./outputs.tf
##  This file contains code written by SevenPico, Inc.
## ----------------------------------------------------------------------------


output "certificate_verification_dns_record" {
  value = try(aws_amplify_domain_association.default[0].certificate_verification_dns_record, "")
}

output "additional_certificate_verification_dns_records" {
  value = try({for i in var.additional_domain_names: i => aws_amplify_domain_association.additional[i].certificate_verification_dns_record }, {})
}

output "domain_name" {
  value = try(aws_amplify_domain_association.default[0].domain_name, "")
}

output "app_name" {
  value = try(aws_amplify_app.default[0].name, "")
}

output "sub_domain" {
  value = try(aws_amplify_domain_association.default[0].sub_domain, "")
}

output "additional_domain_names" {
  value = try({for i in var.additional_domain_names: i => aws_amplify_domain_association.additional[i].domain_name }, {})
}

output "additional_sub_domains" {
  value = try({for i in var.additional_domain_names: i => aws_amplify_domain_association.additional[i].sub_domain }, {})
}

