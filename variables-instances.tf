# Instance sizing, AMI overrides, and software-version variables.
#
# Terraform/OpenTofu loads every *.tf file in this directory, so this split
# from variables.tf is behavior-neutral — just a smaller root variables.tf.

# --- Instances ----------------------------------------------------------------

variable "key_pair_name" {
  description = "Existing EC2 key pair to use for all instances. Leave null to generate a throwaway key pair with the environment."
  type        = string
  default     = null
}

variable "generated_password_length" {
  description = "Length of generated admin passwords (Splunk admin, Windows Administrator) when none are supplied."
  type        = number
  default     = 24

  validation {
    condition     = var.generated_password_length >= 12 && var.generated_password_length <= 128
    error_message = "generated_password_length must be between 12 and 128."
  }
}

variable "nat_instance_type" {
  description = "Instance type for the NAT instance. ARM/Graviton types work here (the NAT AMI is arm64)."
  type        = string
  default     = "t4g.nano"
}

variable "splunk_instance_type" {
  description = "Instance type for the Splunk instance. Must be x86_64 — Splunk Enterprise has no public ARM64 release."
  type        = string
  default     = "t3a.small"

  validation {
    condition     = !can(regex("(^a1\\.|[0-9]g\\.)", var.splunk_instance_type))
    error_message = "splunk_instance_type must be x86_64. ARM/Graviton families (e.g., t4g.*, c6g.*, m6g.*, a1.*) are not supported — Splunk Enterprise has no public ARM64 release."
  }
}

variable "splunk_root_volume_size" {
  description = "Size of the Splunk root volume (GB)."
  type        = number
  default     = 20
}

variable "splunk_data_volume_size" {
  description = "Size of the dedicated Splunk data volume mounted at /opt/splunk (GB). Index data lives here."
  type        = number
  default     = 50
}

variable "cribl_stream_instance_type" {
  description = "Instance type for Cribl Stream. Must be x86_64."
  type        = string
  default     = "t3a.small"

  validation {
    condition     = !can(regex("(^a1\\.|[0-9]+g[a-z]*\\.)", var.cribl_stream_instance_type))
    error_message = "cribl_stream_instance_type must be x86_64. ARM/Graviton families are not supported."
  }
}

variable "cribl_edge_instance_type" {
  description = "Instance type for the Cribl Edge Windows instance. Must be x86_64."
  type        = string
  default     = "t3a.medium"

  validation {
    condition     = !can(regex("(^a1\\.|[0-9]+g[a-z]*\\.)", var.cribl_edge_instance_type))
    error_message = "cribl_edge_instance_type must be x86_64. ARM/Graviton families are not supported."
  }
}

variable "splunk_public_access" {
  description = "Place workload instances in a public subnet with public IPs. When false (the default) they live in private subnets behind the NAT instance."
  type        = bool
  default     = false
}

# --- AMI overrides ------------------------------------------------------------
# Leave null to use the latest matching Amazon-owned AMI; set to pin an image
# or substitute a hardened base AMI.

variable "nat_ami_id" {
  description = "Override AMI for the NAT instance (arm64 Amazon Linux expected)."
  type        = string
  default     = null
}

variable "splunk_ami_id" {
  description = "Override AMI for the Splunk instance (x86_64 Amazon Linux expected)."
  type        = string
  default     = null
}

variable "cribl_stream_ami_id" {
  description = "Override AMI for the Cribl Stream instance (x86_64 Amazon Linux expected)."
  type        = string
  default     = null
}

variable "cribl_edge_ami_id" {
  description = "Override AMI for the Cribl Edge instance (Windows Server expected)."
  type        = string
  default     = null
}

# --- Software versions --------------------------------------------------------

variable "splunk_version" {
  description = "Splunk Enterprise version to install."
  type        = string
  default     = "9.4.9"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.splunk_version))
    error_message = "Splunk version must be in X.Y.Z format (e.g., 9.4.9)."
  }
}

variable "splunk_build" {
  description = "Splunk Enterprise build hash used in the download URL."
  type        = string
  default     = "03bb451d4e07"

  validation {
    condition     = can(regex("^[a-f0-9]{12}$", var.splunk_build))
    error_message = "Splunk build must be a 12-character hexadecimal string."
  }
}

variable "splunk_download_base_url" {
  description = "Base URL for Splunk package downloads. Point at an internal mirror if instances cannot reach the vendor CDN."
  type        = string
  default     = "https://download.splunk.com"
}

variable "cribl_version" {
  description = "Cribl Stream/Edge version to install."
  type        = string
  default     = "4.16.1"
}

variable "cribl_build" {
  description = "Cribl build identifier used in the download URL."
  type        = string
  default     = "20904e45"
}

variable "cribl_download_base_url" {
  description = "Base URL for Cribl package downloads. Point at an internal mirror if instances cannot reach the vendor CDN."
  type        = string
  default     = "https://cdn.cribl.io"
}
