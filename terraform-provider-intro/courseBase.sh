# Install Terraform and init config

# Install unzip - Katacoda docker image doesn't have unzip
curl -O https://releases.hashicorp.com/terraform/0.13.0-rc1/terraform_0.13.0-rc1_linux_amd64.zip
unzip terraform_0.13.0-rc1_linux_amd64.zip -d /usr/local/bin/

# Clone docker compose files
git clone -b katacoda https://github.com/hashicorp/learn-terraform-hashicups-provider
mv learn-terraform-hashicups-provider learn
cd ~/learn/docker_compose

# Install HashiCups provider 
curl -Lo terraform-provider-hashicups https://github.com/hashicorp/terraform-provider-hashicups/releases/download/v0.2/terraform-provider-hashicups_0.2_linux_amd64
chmod +x terraform-provider-hashicups
mkdir -p ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.2/linux_amd64
mv terraform-provider-hashicups ~/.terraform.d/plugins/hashicorp.com/edu/hashicups/0.2/linux_amd64

# Run Docker Compose up
docker-compose up

clear

echo "Ready!"