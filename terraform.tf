terraform {
  required_version = ">=1.8"
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = ">=4.8.0"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = ">=0.51.0"
    }
  }
}
