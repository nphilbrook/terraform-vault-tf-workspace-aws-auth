# Terraform Vault TF Workspace AWS Authentication

This Terraform module provides configuration for authenticating HCP Terraform workspaces with Vault's AWS secrets engine. It:

1. Creates a JWT auth role in Vault that is bound to a specific workspace
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


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.8 |
| <a name="requirement_tfe"></a> [tfe](#requirement\_tfe) | >=0.51.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | >=4.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | 0.67.0 |
| <a name="provider_vault"></a> [vault](#provider\_vault) | 5.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tfe_variable.vault_backed_aws_additional_role_arns](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_auth_additional](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_run_role_arn](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_run_vault_role](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [tfe_variable.vault_backed_aws_run_vault_role_additional](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/variable) | resource |
| [vault_aws_secret_backend_role.vault_aws_role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/aws_secret_backend_role) | resource |
| [vault_jwt_auth_backend_role.vault_jwt_tf_workspace_role](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/jwt_auth_backend_role) | resource |
| [vault_policy.tf_workspace_aws_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy) | resource |
| [vault_policy_document.tf_workspace_aws_policy](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/data-sources/policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_ids"></a> [aws\_account\_ids](#input\_aws\_account\_ids) | List of AWS account IDs to use for dynamic credentials. | `list(string)` | n/a | yes |
| <a name="input_aws_engine_path"></a> [aws\_engine\_path](#input\_aws\_engine\_path) | The path to the AWS secrets engine in Vault. | `string` | `"aws"` | no |
| <a name="input_aws_iam_role_name"></a> [aws\_iam\_role\_name](#input\_aws\_iam\_role\_name) | The name of the AWS IAM role for which Vault will generate assume\_role credentials. | `string` | n/a | yes |
| <a name="input_jwt_auth_path"></a> [jwt\_auth\_path](#input\_jwt\_auth\_path) | The path to the JWT auth backend in Vault. | `string` | `"jwt"` | no |
| <a name="input_tf_organization"></a> [tf\_organization](#input\_tf\_organization) | The HCP Terraform organization to use in JWT claims. | `string` | n/a | yes |
| <a name="input_vault_namespace_path"></a> [vault\_namespace\_path](#input\_vault\_namespace\_path) | Path to the Vault namespace where the JWT auth mount and AWS secrets engine already exist. If omitted, no namespace will be provided to resources and the Vault provider namespace will be used. | `string` | `null` | no |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | The ID of the HCP Terraform Cloud workspace that will use this authentication. | `string` | n/a | yes |
| <a name="input_workspace_name"></a> [workspace\_name](#input\_workspace\_name) | The name of the HCP Terraform Cloud workspace that will use this authentication. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_secret_backend_role_name"></a> [aws\_secret\_backend\_role\_name](#output\_aws\_secret\_backend\_role\_name) | The name of the AWS secret backend role created for the workspace. |
| <a name="output_jwt_auth_role_name"></a> [jwt\_auth\_role\_name](#output\_jwt\_auth\_role\_name) | The name of the JWT auth role created for the workspace. |
<!-- END_TF_DOCS -->