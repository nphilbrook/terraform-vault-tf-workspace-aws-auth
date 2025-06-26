# Example of how to use this module
# The example below configures Vault roles and TFC workspace variables

provider "vault" {
  # Vault provider configuration
  # Typically configured via environment variables:
  # VAULT_ADDR, VAULT_TOKEN, etc.
}

provider "tfe" {
  # TFE provider configuration
  # Typically configured via environment variables:
  # TFE_TOKEN, etc.
}

module "tfe_workspace_aws_auth" {
  source = "../../"

  workspace_name    = "example-workspace"
  workspace_id      = "ws-12345678-1234-1234-1234-123456789012"
  aws_account_ids   = ["123456789012", "210987654321"]
  aws_iam_role_name = "tf-deployment-role"
  tf_organization   = "example-org"

  vault_namespace_path = "admin/live/example"
}

output "jwt_auth_role_name" {
  value = module.tfe_workspace_aws_auth.jwt_auth_role_name
}

output "aws_secret_backend_role_name" {
  value = module.tfe_workspace_aws_auth.aws_secret_backend_role_name
}

output "policy_name" {
  value = module.tfe_workspace_aws_auth.policy_name
}

output "workspace_id" {
  value = module.tfe_workspace_aws_auth.workspace_id
}

output "workspace_name" {
  value = module.tfe_workspace_aws_auth.workspace_name
}
