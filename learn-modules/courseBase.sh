# Clone terraform modules repo
git clone https://github.com/hashicorp/learn-terraform-modules.git
cd learn-terraform-modules
git checkout ec2-instances

# Add Terraform Cloud config
echo -e "// terraform {
//   backend \"remote\" {
//     organization = \"my-organization\"
//     workspaces {
//       name = \"learn-terraform-modules\"
//     }
//   }
// }
\n$(cat ~/tutorial/learn-terraform-modules/main.tf)" > ~/tutorial/learn-terraform-modules/main.tf

cat <<EOT >> ~/tutorial/.terraformrc
credentials "app.terraform.io" {
  token = ""
}
EOT

echo "Ready!"