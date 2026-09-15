# Root module variables.
#
# Every variable has a working default so `tofu plan` succeeds with zero
# inputs. Environment-specific values live in envs/<env>.tfvars; secrets are
# passed via TF_VAR_* environment variables or generated at apply time.

# --- Deployment context -------------------------------------------------------

variable "environment" {
  description = "Environment name used to namespace all resources (e.g. dev, stg, prod)."
  type        = string
  default     = "dev"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,15}$", var.environment))
    error_message = "environment must be 2-16 chars: lowercase letters, digits, hyphens; starting with a letter."
  }
}

variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-2"
}

variable "project_tag" {
  description = "Value of the Project tag applied to every resource. The auto-stop guardrail and the summon role target instances by this tag, so all instances in scope must share it."
  type        = string
  default     = "splunk-aws"
}

# --- Feature toggles ----------------------------------------------------------

variable "enable_splunk" {
  description = "Deploy the Splunk Enterprise instance and its supporting resources (security group, IAM role, SSM password parameter). Splunk and Cribl can be enabled independently."
  type        = bool
  default     = true
}

variable "enable_cribl" {
  description = "Deploy the Cribl Stream (Linux) and Cribl Edge (Windows) instances and their supporting resources. Splunk and Cribl can be enabled independently."
  type        = bool
  default     = false
}

variable "enable_auto_stop" {
  description = "Stop every Project-tagged instance on stop_schedule_expression via the AWS-StopEC2Instance runbook. On by default — this is the primary cost control. A daily schedule caps runtime at under 24 hours."
  type        = bool
  default     = true
}

variable "stop_schedule_expression" {
  description = "EventBridge Scheduler expression for the scheduled stop. Default nightly 08:00 UTC."
  type        = string
  default     = "cron(0 8 * * ? *)"

  validation {
    condition     = can(regex("^(cron|rate)\\(", var.stop_schedule_expression))
    error_message = "stop_schedule_expression must be a cron(...) or rate(...) expression."
  }
}

variable "enable_github_summon" {
  description = "Create the GitHub Actions OIDC role that lets the summon workflow start/stop this environment without AWS credentials. Requires github_repository."
  type        = bool
  default     = false
}

variable "github_repository" {
  description = "GitHub repository (owner/name) trusted to assume the summon role. Required when enable_github_summon = true."
  type        = string
  default     = ""

  validation {
    condition     = var.github_repository == "" || can(regex("^[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$", var.github_repository))
    error_message = "github_repository must be in owner/name form, e.g. my-org/tf-splunk-aws."
  }
}

variable "github_oidc_provider_arn" {
  description = "ARN of an existing GitHub Actions OIDC identity provider to reuse. Leave null to create one (an AWS account can only hold one provider per issuer URL)."
  type        = string
  default     = null
}
