# Install Terraform and init config
cd ~
curl -O https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip -d /usr/local/bin/
export HOME=~/tutorial
cd ~

# Add Terraform Cloud config
cat <<EOT >> ~/tutorial/main.tf
// terraform {
//   backend \"remote\" {
//     organization = \"my-organization\"
//     workspaces {
//       name = \"getting-started\"
//     }
//   }
// }
\n\n
EOT

cat <<EOT >> ~/tutorial/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

echo "Ready!"