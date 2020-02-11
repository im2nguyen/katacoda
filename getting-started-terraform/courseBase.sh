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
EOT

cat <<EOT >> ~/tutorial/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

echo "Ready!"