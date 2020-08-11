# Install Terraform and init config

# Install Terraform
# curl -O https://releases.hashicorp.com/terraform/0.13.0-rc1/terraform_0.13.0-rc1_linux_amd64.zip
# unzip terraform_0.13.0-rc1_linux_amd64.zip -d /usr/local/bin/

# # Pre-configure services to start in localstack
# echo "version: '3.2'
# services:
#   localstack:
#     image: localstack/localstack:latest
#     container_name: localstack_demo
#     ports:
#       - '4563-4584:4563-4584'
#       - '8055:8080'
#     environment:
#       - SERVICES=s3
#       - DEBUG=1
#       - DATA_DIR=/tmp/localstack/data
#     volumes:
#       - './.localstack:/tmp/localstack'
#       - '/var/run/docker.sock:/var/run/docker.sock'
# " > docker_compose.yml

# # Run localstack in daemon
# docker-compose up
