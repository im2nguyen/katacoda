#!/bin/sh

# Install Terraform and init config
cd ~
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/
export HOME=~/tutorial
cd $HOME

# Add Terraform Cloud config
echo -e "// terraform {
//   backend \"remote\" {
//     organization = \"my-organization\"
//     workspaces {
//       name = \"learn-terraform-modules\"
//     }
//   }
// }
\n\n$(cat ~/learn-terraform-modules/main.tf)" > ~/main.tf

cat <<EOT >> ~/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

# Check helm and minikube completion
source <(helm completion bash)
source <(minikube completion bash)

minikube addons enable metrics-server
clear

echo "Ready!"