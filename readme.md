# Terraform IaC for test-project
# Step 1:
 ## terraform init
# Step 2:
 ## terraform workspace new dev
# Step 3:
 ## terraform workspace new prod
# Step 4:
 ## Select any one with workspace select


# Set secrets via environment variables
## export TF_VAR_sql_username=(the username)
## export TF_VAR_sql_password=(the password)
# When you run Terraform, it'll pick up the secrets automatically
## terraform apply
## terraform plan to see all the resources created

 terraform apply to apply whole infra

## refer this for cloudfront caching policy id
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-cache-policies.html#managed-cache-policy-caching-disabled
