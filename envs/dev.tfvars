# dev environment.
# Only values that differ from the variable defaults are set here. Secrets and
# operator IPs come from the environment, not this file:
#   TF_VAR_splunk_admin_password  (optional — generated when unset)
#   TF_VAR_admin_ip_cidrs         e.g. '["203.0.113.7/32"]'

environment = "dev"

# Deploy Splunk Enterprise in dev (Cribl disabled by default).
enable_splunk = true
enable_cribl  = false

# Dev is operated over the internet: public IPs + allowlisted access.
splunk_public_access = true

# 24/7 continuous operation: do not shut down automatically.
enable_auto_stop = false

# Credential-less start/stop from the Actions tab. Set the repository slug,
# then flip this on.
enable_github_summon = false
# github_repository  = "VisiCore/tofu-splunk-aws"
