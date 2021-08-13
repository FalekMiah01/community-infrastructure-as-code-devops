#####################################################################################################################################
##### Terraform State
###################################################################################################################################

platform_state_key_name             = "<Enter your state_file_name>"
platform_state_container_name       = "<Enter your state_container_name>"
platform_state_storage_account_name = "<Enter your state_storage_account_name>"
platform_state_resource_group_name  = "<Enter your state_resource_group_name>"

###################################################################################################################################
#### Azure Resource
###################################################################################################################################

tenant_id           = "<Enter your tenant_id>"
subscription_id     = "<Enter your subscription_id>"
azure_short_region  = "uks"
azure_region        = "UK South"
resource_group_name = "rg-databrickslabs"

###################################################################################################################################
#### Databricks
###################################################################################################################################

databricks_name                        = "dbrickslabs-ws"
databricks_managed_resource_group_name = "rg-databrickslabs-mrg"
databricks_sku_name                    = "standard"
secret_scope_name                      = "databrickslabs-scope"
databricks_token_name                  = "databrickslabs-token"

cluster_name                            = "databrickslabs-cluster"
spark_version                           = "7.3.x-scala2.12"
node_type_id                            = "Standard_DS3_v2"

autotermination_minutes                 = "20"
min_workers                             = "1"
max_workers                             = "4"

notebook_path                           = "/Shared/Demo/example_notebook"