#!/bin/sh

# Check helm and minikube completion
source <(helm completion bash)
source <(minikube completion bash)

minikube addons enable metrics-server

# fetch Terraform archive
curl -O  https://releases.hashicorp.com/terraform/0.13.5/terraform_0.13.5_linux_amd64.zip

# unzip Terraform archive and make it accessible in PATH
unzip terraform_0.13.5_linux_amd64.zip -d /usr/local/bin/

# clean up
rm --recursive  --force terraform_0.13.5_linux_amd64.zip

# helm init
helm init

# add `datadog` Helm Charts (this provides `datadog/datadog:2.4.5`)
helm repo add "datadog" "https://helm.datadoghq.com/"

# update Helm Charts
helm repo update

# create user workspace
mkdir -p /root/
mkdir -p /tmp/repo

git clone -b katacoda https://github.com/hashicorp/learn-terraform-datadog.git /tmp/repo

cp /tmp/repo/variables.tf /root/
cp /tmp/repo/terraform.tf /root/
cp /tmp/repo/kubernetes.tf /root/

cd /root/

echo "Ready!"
