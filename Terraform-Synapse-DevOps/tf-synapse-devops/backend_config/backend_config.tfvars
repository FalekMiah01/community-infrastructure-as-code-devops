######################################################################################################################
##### Terraform State & Service Principal
#######################################################################################################################
# <<<< DO NOT CHECK IN  >>>>

## Terraform Backend State
tf_state_backend_key_name             = "tfsynapsedevops.dev.terraform.tfstate" # TO CHANGE: <app_name>.<evn>.terraform.tfstate
tf_state_backend_resource_group_name  = "rg-terraformfm-weu-dev"
tf_state_backend_storage_account_name = "terraformfmblobweu"
tf_state_backend_container_name       = "terraformfm-state-synapse"


## Terraform Service Principal
client_id           = "7438e347-0b68-4192-9ede-87561e328bc1"  # <<<< DO NOT CHECK IN  >>>>
client_secret       = "qx28Q~FrWXVZSDa4RMz_LkNcqcnIh-6~tD1X~bln"    # <<<< DO NOT CHECK IN  >>>>
tenant_id           = "6d2c78dd-1f85-4ccb-9ae3-cd5ea1cca361"  # <<<< DO NOT CHECK IN  >>>>
subscription_id     = "f9197e0e-1333-42c2-84c6-b0b2e48e084a"  # <<<< DO NOT CHECK IN  >>>>