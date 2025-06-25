# Terraform Vault TFE Workspace AWS Authentication

This Terraform module provides configuration for authenticating Terraform Cloud/Enterprise workspaces with Vault's AWS secrets engine. It:

1. Creates a JWT auth role in Vault that is bound to a specific TFE workspace
2. Creates an AWS secrets engine role in Vault with access to one or more AWS accounts
3. Creates a Vault policy granting the JWT auth role access to the AWS secrets engine role
4. Adds all required variables directly to the specified workspace for Vault-backed AWS dynamic provider credentials

## Usage

```hcl
module "tfe_workspace_aws_auth" {
  source = "path/to/terraform-vault-tfe-workspace-aws-auth"

  workspace_name   = "my-terraform-workspace"
  aws_account_ids  = ["123456789012", "210987654321"]
  aws_iam_role_name = "vault-assumable-role"
  tf_organization  = "my-terraform-org"

  # Optional parameters with defaults
  vault_namespace_path = "admin/example"
  jwt_auth_path       = "jwt"
  aws_engine_path     = "aws"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.8 |
| vault | >= 4.8.0 |
| tfe | >= 0.51.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| workspace_name | The name of the Terraform Cloud/Enterprise workspace that will use this authentication. | `string` | n/a | yes |
| aws_account_ids | List of AWS account IDs to use for dynamic credentials. | `list(string)` | n/a | yes |
| aws_iam_role_name | The name of the AWS IAM role for which Vault will generate assume_role credentials. | `string` | n/a | yes |
| tf_organization | The HCP Terraform organization to use in JWT claims. | `string` | n/a | yes |
| vault_namespace_path | Path to the Vault namespace where the JWT auth mount and AWS secrets engine already exist. | `string` | `null` | no |
| jwt_auth_path | The path to the JWT auth backend in Vault. | `string` | `"jwt"` | no |
| aws_engine_path | The path to the AWS secrets engine in Vault. | `string` | `"aws"` | no |

## Outputs

| Name | Description |
|------|-------------|
| jwt_auth_role_name | The name of the JWT auth role created for the workspace. |
| aws_secret_backend_role_name | The name of the AWS secret backend role created for the workspace. |
| policy_name | The name of the Vault policy created for the workspace. |
| workspace_id | The ID of the TFE workspace. |
| workspace_name | The name of the TFE workspace. |

## Workspace Variables

This module automatically adds all the required variables to the specified Terraform Cloud/Enterprise workspace for Vault-backed AWS dynamic provider credentials, including:

- Primary AWS account (first in the list) configured as the default provider
- Additional AWS accounts (if any) configured as provider aliases with appropriate tags
- All required authentication variables

Note: The `tfc_vault_backed_aws_dynamic_credentials` variable is automatically provided by Terraform Cloud at runtime and does not need to be defined in this module.

### Example Provider Configuration

The workspace using this module should include a variable declaration and provider configuration for the AWS dynamic credentials. Terraform Cloud will automatically supply the credential values at runtime:

```hcl
# Define the required variable to accept dynamic credentials
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

# Primary AWS account (default provider)
provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = [var.tfc_vault_backed_aws_dynamic_credentials.default.shared_credentials_file]
}

# Additional AWS accounts as provider aliases (if provided)
provider "aws" {
  alias                    = "ACCT1"  # For the second account in the list
  region                   = "us-east-1"
  shared_credentials_files = [var.tfc_vault_backed_aws_dynamic_credentials.aliases["ACCT1"].shared_credentials_file]
}
```

See the [workspace configuration example](examples/workspace_configuration.tf) for how to set up the variable and provider configuration in the actual workspace.
