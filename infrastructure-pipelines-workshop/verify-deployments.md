## Verify deployments

Now that you have deployed a Vault instance using Consul as a backend on a GKE cluster, you will connect to your Kubernetes cluster using `kubectl` to access the respective instances.

## Configure kubectl

First, login to Terraform Cloud using the CLI.

`terraform init`{{execute}} 

Then, add the following configuration to your KataCoda `main.tf` file. Replace the `organization` and `workspaces` value in [`main.tf`](https://github.com/hashicorp/learn-terraform-pipelines-k8s/blob/master/main.tf). 
- `organization`: "infrastructure-pipelines-workshop"
- `workspaces`  : "{firstName}-{lastInitial}-k8s" 

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

Run the following command. It will save your Kubernetes workspace's `kubeconfig` output value into a file named `kubeconfig`. This will allow you to connect to your cluster.

`terraform output kubeconfig > kubeconfig`{{execute}} 

Check the number of nodes in your Kubernetes deployment.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn get nodes`{{execute}} 

Since Vault and Consul are enabled, you should see 5 nodes.

## Access Consul UI

Run the following command — it forwards port :8500 (Consul UI) to port :8500, allowing you to access it on KataCoda's port 8500.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn port-forward consul-server-0 8500:8500`{{execute}} 

Click on [[HOST_SUBDOMAIN]]-8500-[[KATACODA_HOST]].environments.katacoda.com to access the Consul UI.

> **Note:** The Consul UI does not show Vault in the list of services because its service_registration stanza in the Helm chart defaults to Kubernetes. However, Vault is still configured to use Consul as a backend.

## Access Vault UI

Run the following command — it forwards port :8200 (Vault UI) to port :8200, allowing you to access it on KataCoda's port 8200.

`kubectl --kubeconfig=kubeconfig -n hashicorp-learn port-forward hashicorp-learn-vault-0 8200:8200`{{execute}} 

Click on [[HOST_SUBDOMAIN]]-8200-[[KATACODA_HOST]].environments.katacoda.com to access the Vault UI.

> **Note:** The Vault pods have warnings because it’s sealed. To learn how to unseal the Vault instance, reference the [CLI initialize and unseal documentation for Vault](https://www.vaultproject.io/docs/platform/k8s/helm/run#initialize-and-unseal-vault). Do **not** do this in the workshop.
