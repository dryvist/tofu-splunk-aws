# prod environment.
# Inherits every variable default; override here as production needs diverge.
# Consider disabling the auto-stop guardrail only if prod must run 24/7.

environment = "prod"

enable_splunk = true
enable_cribl  = false

# prod environment runs 24/7 continuous operation.
enable_auto_stop = false
