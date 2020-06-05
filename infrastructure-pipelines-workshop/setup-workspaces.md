## Setup Terraform Cloud workspaces

In this step, you will locate your pre-configured workspaces (Kubernetes, Consul, Vault) in Terraform Cloud. Then, you will connect them to a version control system (VCS), verify the variables are set up properly, then set up run triggers connecting the workspaces.

Check the email address you used to sign up for the workshop. You should find an invitation to join the `infrastructure-pipelines-workshop` workshop. Accept the invite. You should find 3 workspaces starting with your first name and middle initial.  For example, if your name is John Doe, you should see:

- `john-d-k8s`
- `john-d-consul`
- `john-d-vault`

These will be your workspaces for the duration of this workshop.

## Configure Kubernetes workspace

Fork the [Learn Terraform Pipelines K8s repository](https://github.com/hashicorp/learn-terraform-pipelines-k8s). Replace the `organization` and `workspaces` value in [`main.tf`](https://github.com/hashicorp/learn-terraform-pipelines-k8s/blob/master/main.tf). 
- `organization = "infrastructure-pipelines-workshop"`
- `workspaces = "{firstName}-{lastInitial}-k8s"`

```hcl
terraform {
  backend "remote" {
    organization = "infrastructure-pipelines-workshop"

    workspaces {
      name = "john-d-k8s"
    }
  }
}
```
### Connect workspace to forked repository

Click on your Kubernetes workspace (`john-d-k8s`). Click on "Settings" then "Version Control" to access workspace's version control.

![Click on "Settings" then "Version Control" to access workspace version control](./assets/configure-vcs.png)

Then, click on "Connect to version control". Select "Github" — it will ask you to authorize GitHub if this is your first time using Terraform Cloud. Select your **forked** Kubernetes repo: `learn-terraform-pipelines-k8s`. Finally, click "Update VCS settings". This will connect this workspace to your forked Kubernetes repo.

### Verify variables

Next, click on "Variables". Both your Terraform Variables and Environment Variables should already be set for you. These correspond with the variables in [`variables.tf`](https://github.com/hashicorp/learn-terraform-pipelines-k8s/blob/master/variables.tf). Verify your variables have been set correctly.

#### Terraform Variables
- **region** — GCP region to deploy clusters<br/>
  This should be set to `europe-west4`. For a full list of GCP regions, refer to [Google’s Region and Zones documentation](https://cloud.google.com/compute/docs/regions-zones).
- **cluster_name** — Name of Kubernetes cluster<br/>
  This should be set to `tfc-pipelines`.
- **google_project** — Google Project to deploy cluster<br/>
  This should be set to `{firstName}-{lastInitial}-{randomString}`.
- **username** — Username for Kubernetes cluster<br/>
  This can be anything, but defaults to `hashicorp`.
- **password** — Password for Kubernetes cluster<br/>
  This can be anything over 16 characters, but defaults to `infrastructurepipelines`. This should have been marked **sensitive**. Terraform will set this when it creates your Kubernetes cluster and will distribute it as necessary when creating your Consul and Vault clusters. You do not need to manually input this value again.
- **enable_consul_and_vault** — Enable Consul and Vault for the secrets cluster<br/>
  This should be set to **false**. This variable dictates whether Consul and Vault should be deployed on your Kubernetes cluster.

#### Environment Variables
- **GOOGLE_CREDENTIALS** — Flattened JSON of your GCP credentials.<br/>
  This should have already been set for you and marked **sensitive**. It has access to both **Compute Admin** and **GKE Admin**

You have successfully configured your Kubernetes workspace. Terraform cloud will use these values to deploy your Kubernetes cluster. The pipeline will output the Kubernetes credentials for the Helm charts to consume in the Consul and Vault workspaces. These values are specified in [`output.tf`](https://github.com/hashicorp/learn-terraform-pipelines-k8s/blob/master/outputs.tf).

## Configure Consul workspace

Fork the [Learn Terraform Pipelines Consul repository](https://github.com/hashicorp/learn-terraform-pipelines-consul). Replace the `organization` and `workspaces` value in [`main.tf`](https://github.com/hashicorp/learn-terraform-pipelines-consul/blob/master/main.tf). 
- `organization`: "infrastructure-pipelines-workshop"
- `workspaces`  : "{firstName}-{lastInitial}-consul"

```hcl
terraform {
  backend "remote" {
    organization = "infrastructure-pipelines-workshop"

    workspaces {
      name = "john-d-consul"
    }
  }
}
```
### Connect workspace to forked repository

Click on your Consul workspace (`john-d-consul`). Click on "Settings" then "Version Control" to access workspace's version control.

Click on "Connect to version control". Select "Github" then your **forked** Consul repo: `learn-terraform-pipelines-consul`. Finally, click "Update VCS settings". This will connect this workspace to your forked Consul repo.

Select "Include submodules on clone" then click on "Update VCS settings". This will clone any submodules in your Consul repo. 

![Click on "Include submodules on clone" then click on "Update VCS settings"](./assets/include-submodules.png)

### Verify variables

Next, click on "Variables". Your Terraform Variables should already be set for you. These correspond with the variables in [`variables.tf`](https://github.com/hashicorp/learn-terraform-pipelines-consul/blob/master/variables.tf). Verify your variables have been set correctly.

#### Terraform Variables
- **release_name** — Helm Release name for Consul chart<br/>
  This should be set to `hashicorp-learn`. Your Vault pods will start with this release name.
- **namespace** — Kubernetes Namespace to deploy the Consul Helm chart<br/>
  This should be set to `hashicorp-learn`. You will use this to access your Consul and Vault instances later.
- **cluster_workspace** — Workspace that created the Kubernetes cluster<br/>
  This should be set to `{firstName}-{lastInitial}-k8s` (`john-d-k8s`).
- **organization** - Organization of workspace that created the Kubernetes cluster<br/>
  This should be set to `infrastructure-pipelines-workshop`.

### Enable run triggers 

Click on "Settings" then select "Run Triggers".

Under "Source Workspaces", select your Kubernetes workspace(`john-d-k8s`) then click "Add Workspace".

![Select Kubernetes workspace as source workspace](./assets/enable-run-triggers.png)

You have successfully configured your Consul workspace. The pipeline will retrieve the Kubernetes credentials from the Kubernetes workspace to authenticate to the Kubernetes and Helm provider.

## Configure Vault workspace

Fork the [Learn Terraform Pipelines Vault repository](https://github.com/hashicorp/learn-terraform-pipelines-vault). Replace the `organization` and `workspaces` value in [`main.tf`](https://github.com/hashicorp/learn-terraform-pipelines-vault/blob/master/main.tf). 
- `organization`: "infrastructure-pipelines-workshop"
- `workspaces`  : "{firstName}-{lastInitial}-vault"

```hcl
terraform {
  backend "remote" {
    organization = "infrastructure-pipelines-workshop"

    workspaces {
      name = "john-d-vault"
    }
  }
}
```

### Connect workspace to forked repository

Click on your Vault workspace (`john-d-vault`). Click on "Settings" then "Version Control" to access workspace's version control.

Click on "Connect to version control". Select "Github" then your **forked** Vault repo: `learn-terraform-pipelines-vault`. Finally, click "Update VCS settings". This will connect this workspace to your forked Vault repo.

Select "Include submodules on clone" then click on "Update VCS settings". This will clone any submodules in your Consul repo. 

### Verify variables

Next, click on "Variables". Your Terraform Variables should already be set for you. These correspond with the variables in [`variables.tf`](https://github.com/hashicorp/learn-terraform-pipelines-consul/blob/master/variables.tf). Verify your variables have been set correctly.

#### Terraform Variables
- **cluster_workspace** — Terraform Cloud Workspace for the Kubernetes cluster.
  This should be set to `{firstName}-{lastInitial}-k8s` (`john-d-k8s`).
- **consul_workspace** —Terraform Cloud Workspace for the Consul cluster. 
  This should be set to `{firstName}-{lastInitial}-consul` (`john-d-consul`).
- **organization** — Organization of workspace that created the Kubernetes cluster
  This should be set to `infrastructure-pipelines-workshop`.

### Enable run triggers 

Click on "Settings" then select "Run Triggers".

Under "Source Workspaces", select your Consul workspace(`john-d-consul`) then click "Add Workspace".

You have successfully configured your Vault workspace. The pipeline will retrieve the Kubernetes credentials from the Kubernetes workspace to authenticate to the Helm provider; the pipeline will retrieve the Helm release name and Kubernetes namespace from the Consul workspace.

