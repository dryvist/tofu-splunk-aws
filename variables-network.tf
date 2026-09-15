# Networking, access-control, and service-port variables.
#
# Terraform/OpenTofu loads every *.tf file in this directory, so this split
# from variables.tf is behavior-neutral — just a smaller root variables.tf.

# --- Network ------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for the subnets. Defaults to the first two available AZs in aws_region."
  type        = list(string)
  default     = null
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets (NAT instance; workload instances when splunk_public_access = true)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets (default workload placement)."
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# --- Access control -----------------------------------------------------------

variable "admin_ip_cidrs" {
  description = "Operator egress CIDRs granted access to every operator-facing surface (Splunk Web, HEC, management, Cribl). Convenience superset of the per-surface allowlists below. Typically set via TF_VAR_admin_ip_cidrs."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.admin_ip_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Each admin_ip_cidrs entry must be a valid CIDR block, e.g. 203.0.113.7/32."
  }
}

variable "web_allowed_cidrs" {
  description = "CIDR blocks allowed access to Splunk Web. Creates a security group rule whenever non-empty, regardless of splunk_public_access (useful for VPN/peering access to private instances)."
  type        = list(string)
  default     = []
}

variable "hec_allowed_cidrs" {
  description = "CIDR blocks allowed to send data to Splunk HEC. Set to the egress IPs of your data sources."
  type        = list(string)
  default     = []
}

variable "management_allowed_cidrs" {
  description = "CIDR blocks for management ports (RDP, Splunk management) — always restricted, never affected by allow_all_ips. SSH is controlled by ssh_allowed_cidrs."
  type        = list(string)
  default     = []
}

variable "cribl_allowed_cidrs" {
  description = "CIDR blocks for Cribl ports (web/leader UI and data ingest) — affected by allow_all_ips."
  type        = list(string)
  default     = []
}

variable "ssh_allowed_cidrs" {
  description = "CIDR blocks allowed SSH access (port 22). Empty list (the default) creates no SSH rule at all; use SSM Session Manager instead."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for cidr in var.ssh_allowed_cidrs : can(cidrhost(cidr, 0))])
    error_message = "Each ssh_allowed_cidrs entry must be a valid CIDR block, e.g. 203.0.113.0/24."
  }
}

variable "allow_all_ips" {
  description = "Open Splunk Web, HEC, and Cribl ports to 0.0.0.0/0, overriding their allowlists. Intended only for short-lived testing; set via TF_VAR_allow_all_ips=true rather than committing it."
  type        = bool
  default     = false
}

# --- Service ports ------------------------------------------------------------
# Security group rules and service URLs derive from these. Changing a port here
# only changes what is *allowed and advertised* — the service must be configured
# to actually listen on the new port (Splunk and Cribl both default to these).

variable "splunk_web_port" {
  description = "Port Splunk Web listens on."
  type        = number
  default     = 8000
}

variable "splunk_hec_port" {
  description = "Port the Splunk HTTP Event Collector listens on."
  type        = number
  default     = 8088
}

variable "splunk_management_port" {
  description = "Port the Splunk management API (splunkd) listens on."
  type        = number
  default     = 8089
}

variable "splunk_s2s_port" {
  description = "Port for Splunk-to-Splunk forwarding (splunktcp)."
  type        = number
  default     = 9997
}

variable "cribl_web_port" {
  description = "Port for the Cribl web UI and leader/worker communications."
  type        = number
  default     = 4200
}

variable "cribl_data_port" {
  description = "Port for Cribl data ingest."
  type        = number
  default     = 9997
}
