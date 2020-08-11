# Install Terraform and init config

# Install unzip - Katacoda docker image doesn't have unzip
curl -O https://releases.hashicorp.com/terraform/0.13.0-rc1/terraform_0.13.0-rc1_linux_amd64.zip
unzip terraform_0.13.0-rc1_linux_amd64.zip -d /usr/local/bin/

# Clone docker compose files
git clone https://github.com/hashicorp/learn-terraform-hashicups-provider
cd ~/learn-terraform-hashicups-provider/docker_compose

# Run Docker Compose up
docker-compose up

clear

echo "Ready!"