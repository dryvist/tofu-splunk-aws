plugin "aws" {
  enabled = true
  version = "0.48.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

rule "terraform_deprecated_interpolation" { enabled = true }
rule "terraform_deprecated_index" { enabled = true }
rule "terraform_unused_declarations" { enabled = true }
rule "terraform_comment_syntax" { enabled = true }
rule "terraform_documented_outputs" { enabled = true }
rule "terraform_documented_variables" { enabled = true }
rule "terraform_typed_variables" { enabled = true }
rule "terraform_naming_convention" { enabled = true }
rule "terraform_required_version" { enabled = true }
rule "terraform_required_providers" { enabled = true }
# Disabled: this rule hardcodes the requirement that every `variable` block
# live in a file literally named `variables.tf` (no wildcard/alternate-name
# support in any released version of tflint-ruleset-terraform; see
# terraform-linters/tflint-ruleset-terraform#119, open upstream). That is
# unsatisfiable together with this repo's 12 KB per-file size gate, which
# requires splitting variables.tf once it grows past the limit. All other
# rules in this ruleset stay enabled.
rule "terraform_standard_module_structure" { enabled = false }
