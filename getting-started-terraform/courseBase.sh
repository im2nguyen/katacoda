# Add Terraform Cloud config
cat <<EOT >> ~/main.tf
// terraform {
//   backend \"remote\" {
//     organization = \"my-organization\"
//     workspaces {
//       name = \"getting-started\"
//     }
//   }
// }
EOT

cat <<EOT >> ~/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

echo "Ready!"