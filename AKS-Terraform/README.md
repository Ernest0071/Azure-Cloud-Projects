# Terraform Project

This project uses Terraform to provision an AKS Cluster on Azure.

## Prerequisites

Before you can use this project, you need to have the following tools installed:

- [Terraform](https://www.terraform.io/downloads.html)
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)

You also need to have an Azure subscription and an Azure service principal with the necessary permissions to provision resources.

## Getting Started

To get started with this project, follow these steps:

1. Clone the repository to your local machine.
2. Open a terminal or command prompt and navigate to the project directory.
3. Run `./remote-state.sh` to create the remote state backend in Azure Blob Storage.
4. Run `terraform init` to initialize the Terraform configuration.
5. Run `terraform plan` to preview the changes that Terraform will make.
6. Run `terraform apply` to apply the changes and provision the resources.
7. When you're finished, run `terraform destroy` to destroy the resources and clean up.

## Configuration

The project configuration is stored in the `terraform.tfvars` file. You can modify this file to customize the project configuration.

## Contributing

If you want to contribute to this project, please follow these guidelines:

1. Fork the repository and create a new branch for your changes.
2. Make your changes and test them thoroughly.
3. Submit a pull request with a clear description of your changes.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.