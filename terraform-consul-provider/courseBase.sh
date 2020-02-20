# Clone docker compose files
git clone git@github.com:im2nguyen/terraform-consul-playground.git
cd terraform-consul-playground 

# Run Docker Compose up (daemon)
docker-compose up -d

# Create main.tf working file
cd ..
touch main.tf

echo "Ready!"