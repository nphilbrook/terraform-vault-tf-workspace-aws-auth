# Example of Terraform code to add to the workspace code itself
# This shows how to use the dynamic credentials that are set up by the module
# in the multi-AWS account case

# Declare the required variable to accept dynamic credentials
# This variable is defined by HCP Terraform automatically
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

# Additional AWS accounts (if provided)
provider "aws" {
  alias                    = "ACCT1" # For the second account in the list
  region                   = "us-east-1"
  shared_credentials_files = [var.tfc_vault_backed_aws_dynamic_credentials.aliases["ACCT1"].shared_credentials_file]
}
