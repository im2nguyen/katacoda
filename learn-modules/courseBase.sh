# Clone terraform modules repo
git clone https://github.com/hashicorp/learn-terraform-modules.git

# Add Terraform Cloud config
echo -e "// terraform {
//   backend \"remote\" {
//     organization = \"my-organization\"
//     workspaces {
//       name = \"learn-terraform-modules\"
//     }
//   }
// }
\n$(cat ~/learn-terraform-modules/main.tf)" > ~/learn-terraform-modules/main.tf

cat <<EOT >> ~/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

echo "Ready!"