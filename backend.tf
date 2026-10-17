# Remote state backend using AWS S3 with native lockfile locking (OpenTofu >= 1.10).
# No DynamoDB lock table is required.
# Bucket, key, region, and locking are supplied per environment at init time
# via a partial-configuration file:
#
#   tofu init -backend-config=envs/dev.s3.tfbackend
#
# See README.md ("First-time AWS setup") for creating the S3 state bucket.
terraform {
  backend "s3" {}
}
