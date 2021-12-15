terraform {
  # Optional attributes and the defaults function are
  # both experimental, so we must opt in to the experiment.
  experiments = [module_variable_optional_attrs]
  required_providers {
    scalr = {
      source = "registry.scalr.io/scalr/scalr"
      version= "1.0.0-rc25"
    }
  }
}

provider scalr {
}

variable "account_id" {
  type = string
}

variable "environment_id" {
  type = string
}

variable "ws_count" {
  default = 50
}

variable "github_token" {
  sensitive = true
}

variable "vcs_repo" {
  type = object({
    identifier = string
    branch = optional(string)
  })
}

resource "scalr_vcs_provider" "vcs" {
  name = "vcs_from_scalr_provider"
  account_id = var.account_id
  vcs_type="github"
  token = var.github_token
}

resource "scalr_workspace" "me" {
  count = var.ws_count
  name = "ws_from_scalr_provider${count.index}"
  environment_id = var.environment_id
  auto_apply = true
  vcs_repo = var.vcs_repo
  vcs_provider_id = scalr_vcs_provider.vcs.id
}