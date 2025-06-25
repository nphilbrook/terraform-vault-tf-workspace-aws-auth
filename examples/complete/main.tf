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
  aws_account_ids   = ["123456789012", "210987654321"]
  aws_iam_role_name = "terraform-vault-role"
  tf_organization   = "example-org"
  
  vault_namespace_path = "admin/example"
  jwt_auth_path       = "jwt"
  aws_engine_path     = "aws"
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

# Example of how to use the variable set in a Terraform configuration
# This would be in the workspace's configuration, not in this module
/*
variable "tfc_vault_backed_aws_dynamic_credentials" {
  description = "Object containing Vault-backed AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_credentials_file = string
    })
    aliases = map(object({
      shared_credentials_file = string
    }))
  })
}

# Primary AWS account
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = [var.tfc_vault_backed_aws_dynamic_credentials.default.shared_credentials_file]
}

# Secondary AWS account (if provided)
provider "aws" {
  alias                    = "ACCT1"
  region                   = "us-east-1"
  shared_credentials_files = [var.tfc_vault_backed_aws_dynamic_credentials.aliases["ACCT1"].shared_credentials_file]
}
*/
