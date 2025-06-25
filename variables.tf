variable "vault_namespace_path" {
  type        = string
  description = "Path to the Vault namespace where the JWT auth mount and AWS secrets engine already exist. If omitted, no namespace will be provided to resources and the Vault provider namespace will be used."
  default     = null
}

variable "jwt_auth_path" {
  type        = string
  description = "The path to the JWT auth backend in Vault."
  default     = "jwt"
}

variable "aws_engine_path" {
  type        = string
  description = "The path to the AWS secrets engine in Vault."
  default     = "aws"
}

variable "workspace_name" {
  type        = string
  description = "The name of the Terraform Cloud/Enterprise workspace that will use this authentication."
}

variable "workspace_id" {
  type        = string
  description = "The ID of the Terraform Cloud/Enterprise workspace that will use this authentication."
}

# NOTE: To be written

variable "aws_account_ids" {
  type        = list(string)
  description = "List of AWS account IDs to use for dynamic credentials."
}

variable "aws_iam_role_name" {
  type        = string
  description = "The name of the AWS IAM role for which Vault will generate assume_role credentials."
}

variable "tf_organization" {
  type        = string
  description = "The HCP Terraform organization to use in JWT claims."
}
