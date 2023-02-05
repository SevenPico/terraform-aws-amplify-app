#------------------------------------------------------------------------------
# Context
#------------------------------------------------------------------------------
module "iam_context" {
  source     = "app.terraform.io/SevenPico/context/null"
  version    = "1.1.0"
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
  count = module.iam_context.enabled ? 1 : 0

  assume_role_policy  = join("", data.aws_iam_policy_document.amplify_assume_role.*.json)
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
  name                = module.iam_context.id
  tags                = module.iam_context.tags
}

