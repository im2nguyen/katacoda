# Install Terraform and init config
# Install docker, unzip - Ubuntu doesn't have docker, pipe to null so future commands work
# apt-get install -y docker-ce docker-ce-cli containerd.io unzip < "/dev/null"
apt-get install -y unzip < "/dev/null"

# Install unzip - Katacoda docker image doesn't have unzip
# apt-get install unzip
cd ..
curl -O https://releases.hashicorp.com/terraform/0.13.0-rc1/terraform_0.13.0-rc1_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/

# Clone docker compose files
git clone https://github.com/hashicorp/learn-terraform-hashicups-provider
# mv learn-terraform-hashicups-provider/* ~

cd ~/learn-terraform-hashicups-provider/docker_compose

# Run Docker Compose up (daemon)
docker-compose up

# Go back to workspace directory
cd ..

clear

echo "Ready!"