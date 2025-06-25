data "tfe_workspace" "workspace" {
  name         = var.workspace_name
  organization = var.tf_organization
}

# Primary AWS Account - Using the first account in the list
locals {
  primary_aws_account_id     = var.aws_account_ids[0]
  additional_aws_account_ids = length(var.aws_account_ids) > 1 ? slice(var.aws_account_ids, 1, length(var.aws_account_ids)) : []
}

resource "tfe_variable" "vault_backed_aws_run_vault_role" {
  key          = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE"
  value        = vault_aws_secret_backend_role.vault_aws_role.name
  category     = "env"
  description  = "Vault role for AWS authentication"
  workspace_id = data.tfe_workspace.workspace.id
}

# Required for assumed_role auth type
resource "tfe_variable" "vault_backed_aws_run_role_arn" {
  key          = "TFC_VAULT_BACKED_AWS_RUN_ROLE_ARN"
  value        = "arn:aws:iam::${local.primary_aws_account_id}:role/${var.aws_iam_role_name}"
  category     = "env"
  description  = "ARN of the primary AWS role to assume"
  workspace_id = data.tfe_workspace.workspace.id
}

# Additional AWS accounts with tags
resource "tfe_variable" "vault_backed_aws_additional_role_arns" {
  for_each = { for idx, account_id in local.additional_aws_account_ids : account_id => "ACCT${idx + 1}" }

  key          = "TFC_VAULT_BACKED_AWS_RUN_ROLE_ARN_${each.value}"
  value        = "arn:aws:iam::${each.key}:role/${var.aws_iam_role_name}"
  category     = "env"
  description  = "ARN of the AWS role to assume for account ${each.key}"
  workspace_id = data.tfe_workspace.workspace.id
}

# For tagged accounts, we need to set the auth type and vault role as well
resource "tfe_variable" "vault_backed_aws_auth_additional" {
  for_each = { for idx, account_id in local.additional_aws_account_ids : account_id => "ACCT${idx + 1}" }

  key          = "TFC_VAULT_BACKED_AWS_AUTH_${each.value}"
  value        = "true"
  category     = "env"
  description  = "Enable Vault-backed AWS authentication for account ${each.key}"
  workspace_id = data.tfe_workspace.workspace.id
}

resource "tfe_variable" "vault_backed_aws_run_vault_role_additional" {
  for_each = { for idx, account_id in local.additional_aws_account_ids : account_id => "ACCT${idx + 1}" }

  key          = "TFC_VAULT_BACKED_AWS_RUN_VAULT_ROLE_${each.value}"
  value        = vault_aws_secret_backend_role.vault_aws_role.name
  category     = "env"
  description  = "Vault role for AWS authentication for account ${each.key}"
  workspace_id = data.tfe_workspace.workspace.id
}

