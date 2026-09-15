# Secrets and the criblio-managed Cribl config layer variables.
#
# Terraform/OpenTofu loads every *.tf file in this directory, so this split
# from variables.tf is behavior-neutral — just a smaller root variables.tf.

# --- Secrets ------------------------------------------------------------------

variable "splunk_admin_password" {
  description = "Splunk admin password. Leave null (the default) to generate a random password per deployment; retrieve it from the access_credentials output. Set via TF_VAR_splunk_admin_password."
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = var.splunk_admin_password == null || var.splunk_admin_password == "" || length(var.splunk_admin_password) >= 8
    error_message = "Splunk admin password must be at least 8 characters when provided."
  }
}

# --- Cribl config layer (criblio provider) ------------------------------------

variable "enable_criblio_config" {
  description = "Enable the criblio-managed Cribl configuration layer (modules/cribl-config). When false, the layer is a no-op."
  type        = bool
  default     = false
}

variable "cribl_onprem_server_url" {
  description = "On-prem Cribl leader base URL (e.g. http://10.0.10.5:4200). Required when enable_criblio_config = true."
  type        = string
  default     = ""
}

variable "cribl_onprem_bearer_token" {
  description = "Bearer token for the on-prem Cribl leader. Set via TF_VAR_cribl_onprem_bearer_token or CRIBL_BEARER_AUTH."
  type        = string
  default     = ""
  sensitive   = true
}

variable "cribl_cloud_client_id" {
  description = "Cribl.Cloud OAuth2 client_id. Optional; declared for future Cloud workspace use."
  type        = string
  default     = ""
}

variable "cribl_cloud_client_secret" {
  description = "Cribl.Cloud OAuth2 client_secret."
  type        = string
  default     = ""
  sensitive   = true
}

variable "cribl_cloud_organization_id" {
  description = "Cribl.Cloud organization id."
  type        = string
  default     = ""
}

variable "cribl_cloud_workspace_id" {
  description = "Cribl.Cloud workspace id."
  type        = string
  default     = ""
}

variable "cribl_cloud_domain" {
  description = "Cribl.Cloud domain. Provider default is cribl.cloud."
  type        = string
  default     = "cribl.cloud"
}
