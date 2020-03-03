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

# copy kube + minikube configuration to ~ so it's more similar to normal working directory

export HOME=~/home
cp -r ./.kube ~
cp -r ./.minikube ~
cd ~

touch main.tf

clear
echo "Ready!"
