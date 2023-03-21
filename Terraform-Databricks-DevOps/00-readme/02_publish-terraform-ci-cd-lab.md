# Create a basic Pipeline

## 1. Start Setting up Pipeline 

``` yaml
trigger: none
parameters:
  - name: par_environment
    displayName: Enter the Environment Name
    default: dev
    type: string  
variables: 
  terraform_directory: tf05_publish-terraform-ci-cd  
  terraform_version: latest 
  service_connection:  [todo]
  key_vault_name:  [todo]
  tf_state_backend_resource_group_name:  [todo]
  tf_state_backend_resource_group_location: 'UK South' 
  tf_state_backend_storage_account_name: [todo]
  tf_state_backend_container_name: terraform-state-${{ parameters.par_environment }}
  tf_state_backend_key_name: ${{ parameters.par_environment }}.terraform.tfstate

pool:
  vmImage: 'ubuntu-latest'

``` 

## 2. Add a Stage

``` yaml
stages :
 - stage: Validate_Plan_Terraform
    jobs:
    - job: Validate_Plan_Terraform
      displayName: "Validate & Plan Terraform > install, init, validate and plan"
      continueOnError: false
      steps:
      - checkout: self
      - task: AzureKeyVault@1
        displayName: Retrieve key vault secrets
        inputs:
            azureSubscription: $(service_connection)
            keyVaultName: $(key_vault_name)
            secretsFilter: 'ARM-CLIENT-ID, ARM-CLIENT-SECRET, ARM-TENANT-ID, ARM-SUBSCRIPTION-ID'
            runAsPreJob: false
     - task: TerraformInstaller@0
        displayName: Install Terraform
        inputs:
          terraformVersion: $(terraform_version)
```

## 3. Add an init Task

``` yaml
- task: TerraformCLI@0
        displayName: Terraform Init
        inputs:
          command: "init"
          workingDirectory: $(System.DefaultWorkingDirectory)/$(terraform_directory)
          backendType: "azurerm"
          allowTelemetryCollection: true
          backendServiceArm: $(service_connection)
          runAzLogin: true
          ensureBackend: true
          backendAzureRmResourceGroupName: $(tf_state_backend_resource_group_name)
          backendAzureRmResourceGroupLocation: $(tf_state_backend_resource_group_location)
          backendAzureRmStorageAccountName: $(tf_state_backend_storage_account_name)
          backendAzureRmContainerName: $(tf_state_backend_container_name)
          backendAzureRmKey: '$(tf_state_backend_key_name)'
        env:
            ARM_CLIENT_ID: $(ARM-CLIENT-ID)
            ARM_CLIENT_SECRET: $(ARM-CLIENT-SECRET)
            ARM_SUBSCRIPTION_ID: $(ARM-SUBSCRIPTION-ID)
            ARM_TENANT_ID: $(ARM-TENANT-ID)
```

## 4. Add an validate Task

``` yaml
- task: TerraformCLI@0
        displayName: Terraform Validate
        inputs:
          command: "validate"
          workingDirectory: $(System.DefaultWorkingDirectory)/$(terraform_directory)
          backendType: "azurerm"
          allowTelemetryCollection: true
          backendServiceArm: $(service_connection)
          runAzLogin: true
          ensureBackend: true
          backendAzureRmResourceGroupName: $(tf_state_backend_resource_group_name)
          backendAzureRmResourceGroupLocation: $(tf_state_backend_resource_group_location)
          backendAzureRmStorageAccountName: $(tf_state_backend_storage_account_name)
          backendAzureRmContainerName: $(tf_state_backend_container_name)
          backendAzureRmKey: '$(tf_state_backend_key_name)'
        env:
            ARM_CLIENT_ID: $(ARM-CLIENT-ID)
            ARM_CLIENT_SECRET: $(ARM-CLIENT-SECRET)
            ARM_SUBSCRIPTION_ID: $(ARM-SUBSCRIPTION-ID)
            ARM_TENANT_ID: $(ARM-TENANT-ID)
```

## 5. Add an plan Task

``` yaml
- task: TerraformCLI@0
        displayName: Terraform Plan
        inputs:
          command: "plan"
          workingDirectory: $(System.DefaultWorkingDirectory)/$(terraform_directory)
          backendType: "azurerm"
          allowTelemetryCollection: true
          backendServiceArm: $(service_connection)
          runAzLogin: true
          ensureBackend: true
          backendAzureRmResourceGroupName: $(tf_state_backend_resource_group_name)
          backendAzureRmResourceGroupLocation: $(tf_state_backend_resource_group_location)
          backendAzureRmStorageAccountName: $(tf_state_backend_storage_account_name)
          backendAzureRmContainerName: $(tf_state_backend_container_name)
          backendAzureRmKey: '$(tf_state_backend_key_name)'
        env:
            ARM_CLIENT_ID: $(ARM-CLIENT-ID)
            ARM_CLIENT_SECRET: $(ARM-CLIENT-SECRET)
            ARM_SUBSCRIPTION_ID: $(ARM-SUBSCRIPTION-ID)
            ARM_TENANT_ID: $(ARM-TENANT-ID)
```

## 5. Add an apply Task

``` yaml
- task: TerraformCLI@0
        displayName: Terraform Apply
        inputs:
          command: "apply"
          commandOptions: "-var environment=${{ parameters.par_environment }}"              
          workingDirectory: $(System.DefaultWorkingDirectory)/$(terraform_directory)
          backendType: "azurerm"
          allowTelemetryCollection: true
          backendServiceArm: $(service_connection)
          runAzLogin: true
          ensureBackend: true
          backendAzureRmResourceGroupName: $(tf_state_backend_resource_group_name)
          backendAzureRmResourceGroupLocation: $(tf_state_backend_resource_group_location)
          backendAzureRmStorageAccountName: $(tf_state_backend_storage_account_name)
          backendAzureRmContainerName: $(tf_state_backend_container_name)
          backendAzureRmKey: '$(tf_state_backend_key_name)'
        env:
            ARM_CLIENT_ID: $(ARM-CLIENT-ID)
            ARM_CLIENT_SECRET: $(ARM-CLIENT-SECRET)
            ARM_SUBSCRIPTION_ID: $(ARM-SUBSCRIPTION-ID)
            ARM_TENANT_ID: $(ARM-TENANT-ID)
```