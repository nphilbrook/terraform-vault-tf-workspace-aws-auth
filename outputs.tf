output "jwt_auth_role_name" {
  description = "The name of the JWT auth role created for the workspace."
  value       = vault_jwt_auth_backend_role.vault_jwt_tf_workspace_role.role_name
}

output "aws_secret_backend_role_name" {
  description = "The name of the AWS secret backend role created for the workspace."
  value       = vault_aws_secret_backend_role.vault_aws_role.name
}
