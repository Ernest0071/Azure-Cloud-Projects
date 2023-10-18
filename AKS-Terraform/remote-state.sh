#!/bin/bash

# Function to create a resource group
create_resource_group() {
    local rg_name="$1"
    local location="$2"

    # Check if the resource group already exists
    if az group show --name "$rg_name" &> /dev/null; then
        echo "Resource group '$rg_name' already exists."
    else
        # Create the resource group
        az group create --name "$rg_name" --location "$location" --tags 'Project=Terraform' 'Env=Demo'
        if [ $? -ne 0 ]; then
            echo "Error creating resource group '$rg_name'."
            exit 1
        else
            echo "Resource group '$rg_name' created successfully."
        fi
    fi
}

# Function to create a storage account
create_storage_account() {
    local rg_name="$1"
    local sa_name="$2"

    # Check if the storage account already exists
    if az storage account show --name "$sa_name" --resource-group "$rg_name" &> /dev/null; then
        echo "Storage account '$sa_name' is already taken."
    else
        # Create the storage account
        az storage account create --resource-group "$rg_name" --name "$sa_name" --sku Standard_LRS --encryption-services blob
        if [ $? -ne 0 ]; then
            echo "Error creating storage account '$sa_name' in resource group '$rg_name'."
            exit 1
        else
            echo "Storage account '$sa_name' created successfully in resource group '$rg_name'."
        fi
    fi

    # Get the connection string for the storage account
    connection_string=$(az storage account show-connection-string --name "$sa_name" --resource-group "$rg_name" --query 'connectionString' --output tsv)
    if [ $? -ne 0 ]; then
        echo "Error retrieving connection string for storage account '$sa_name'."
        exit 1
    fi
}



# Main script

# Login to Azure (if not already logged in)
az account show 1> /dev/null || az login

rg=terraform-state-rg
sa=tfstatedevpractice
container=tfstate

# Create the resource group
create_resource_group "$rg" "eastus"

# Create the storage account
create_storage_account "$rg" "$sa"

# Create the storage container
az storage container create --name "$container" --connection-string "$connection_string"
if [ $? -ne 0 ]; then
    echo "Error creating storage container '$container' in storage account '$sa'."
    exit 1
else
    echo "Storage container '$container' created successfully in storage account '$sa'."
fi