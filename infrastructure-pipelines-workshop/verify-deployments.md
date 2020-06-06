## Verify deployments

Now that you have deployed a Vault instance using Consul as a backend on a GKE cluster, you will connect to your Kubernetes cluster using `kubectl` to access the respective instances.

## Login with the Terraform CLI

First, login to Terraform Cloud using the CLI.

`terraform login`{{execute}} 

The command output will ask you if you want to confirm that you want to generate a token and store it. Confirm when it prompts you. 

`yes`{{execute}} 

Terraform will prompt you to visit a link in the output. 

Follow this link and generate a new token in Terraform cloud. 

Copy the API token from Terraform Cloud and then paste it into the Katacoda terminal and press enter to confirm. The terminal will not display the token, so only paste your token once.

## Configure kubectl

Add the following configuration to your KataCoda `main.tf` file, replacing the `workspaces` value in [`main.tf`](https://github.com/hashicorp/learn-terraform-pipelines-k8s/blob/master/main.tf). 

- `workspaces = "{firstName}-{lastInitial}-k8s"` 

This will establish a connection to your Kubernetes workspace. 

<pre class="file" data-filename="main.tf" data-target="replace">
terraform {
  backend "remote" {
    organization = "infrastructure-pipelines-workshop"

    workspaces {
      name = "john-d-k8s"
    }
  }
}
</pre>

Then, initialize your Terraform workspace.

`terraform init`{{execute}} 

Run the following command. It will save your Kubernetes workspace's `kubeconfig` output value into a file named `kubeconfig`. This will allow you to connect to your cluster.

`terraform output kubeconfig > kubeconfig`{{execute}} 

Check the number of nodes in your Kubernetes deployment.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn get nodes`{{execute}} 

Since Vault and Consul are enabled, you should see 5 nodes.

## Access Consul UI

Run the following command — it forwards port :8500 (Consul UI) to port :8500, allowing you to access it on KataCoda's port 8500.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn port-forward --address 0.0.0.0 consul-server-0 8500:8500`{{execute}} 

Go to `[[HOST_SUBDOMAIN]]-8500-[[KATACODA_HOST]].environments.katacoda.com` to access the Consul UI.

> **Note:** The Consul UI does not show Vault in the list of services because its service_registration stanza in the Helm chart defaults to Kubernetes. However, Vault is still configured to use Consul as a backend.

## Access Vault UI

Run the following command — it forwards port :8200 (Vault UI) to port :8200, allowing you to access it on KataCoda's port 8200.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn port-forward --address 0.0.0.0 hashicorp-learn-vault-0 8200:8200`{{execute T2}}

Go to `[[HOST_SUBDOMAIN]]-8200-[[KATACODA_HOST]].environments.katacoda.com` to access the Vault UI.

> **Note:** The Vault pods have warnings because it’s sealed. To learn how to unseal the Vault instance, reference the [CLI initialize and unseal documentation for Vault](https://www.vaultproject.io/docs/platform/k8s/helm/run#initialize-and-unseal-vault). Do **not** do this in the workshop.
