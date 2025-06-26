resource "vault_jwt_auth_backend_role" "vault_jwt_tf_workspace_role" {
  namespace = var.vault_namespace_path
  backend   = var.jwt_auth_path
  role_name = "tf-workspace-${var.workspace_name}"

  token_policies = ["default", vault_policy.tf_workspace_aws_policy.name]

  bound_audiences = ["vault.workload.identity"]
  bound_claims = {
    sub = "organization:${var.tf_organization}:project:*:workspace:${var.workspace_name}:run_phase:*"
  }

  bound_claims_type = "glob"
  user_claim        = "terraform_workspace_id"
  role_type         = "jwt"
}

resource "vault_aws_secret_backend_role" "vault_aws_role" {
  namespace       = var.vault_namespace_path
  backend         = var.aws_engine_path
  name            = "tf-workspace-${var.workspace_name}"
  credential_type = "assumed_role"
  role_arns       = [for account_id in var.aws_account_ids : "arn:aws:iam::${account_id}:role/${var.aws_iam_role_name}"]
}

resource "vault_policy" "tf_workspace_aws_policy" {
  namespace = var.vault_namespace_path
  name      = "tf-workspace-${var.workspace_name}"
  policy    = data.vault_policy_document.tf_workspace_aws_policy.hcl
}

data "vault_policy_document" "tf_workspace_aws_policy" {
  rule {
    path         = "${var.aws_engine_path}/creds/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read"]
    description  = "Read dynamic AWS credentials for the specified workspace role"
  }

  rule {
    path         = "${var.aws_engine_path}/sts/${vault_aws_secret_backend_role.vault_aws_role.name}"
    capabilities = ["read", "update", "create"]
    description  = "Read dynamic AWS credentials for the specified workspace role with the STS path"
  }
}
