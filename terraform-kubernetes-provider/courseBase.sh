#!/bin/sh

# Check helm and minikube completion
source <(helm completion bash)
source <(minikube completion bash)

minikube addons enable metrics-server

# Install Terraform and init config
cd ~
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

mkdir home
cd ~/home

touch main.tf
