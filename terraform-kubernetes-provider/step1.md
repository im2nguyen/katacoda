---
id: getting-started-terraform-kubernetes-provider
level: Getting Started
products_used:
  - Terraform
name: Get Started with the Terraform Kubernetes Provider
description: Learn how to schedule deployments and services via Terraform
content_length: 20
---

[Kubernetes](https://kubernetes.io/) (K8S) is an open-source workload scheduler 
with focus on containerized applications. The Terraform Kubernetes (K8S) provider 
is used to interact with the resources supported by Kubernetes. 

### Why Terraform

While you could use kubectl or similar CLI-based tools mapped to API calls to 
manage all Kubernetes resources described in YAML files, orchestration with 
Terraform presents the following benefits:

-	**Unified Workflow** - Use the same configuration language to provision the 
 Kubernetes infrastructure and to deploy applications into it.

-	**Drift Detection** - `terraform plan` will always present you the difference 
 between reality at a given time and config you intend to apply.

-	**Full Lifecycle Management** - Terraform doesn't just initially create 
 resources, but offers a single command for creation, update, and deletion of 
 tracked resources without needing to inspect the API to identify those 
 resources.

-	**Synchronous Feedback** - While asynchronous behaviour is often useful, 
 sometimes it's counter-productive as the job of identifying operation result 
 (failures or details of created resource) is left to the user. e.g. you don't 
 have  IP/hostname of load balancer until it has finished provisioning, hence 
 you can't create any DNS record pointing to it.

-	**Graph of Relationships** - Terraform understands relationships between 
 resources which may help in scheduling - e.g. if a Persistent Volume Claim 
 claims space from a particular Persistent Volume Terraform won't even attempt 
 to create the PVC if creation of the PV has failed.

In this guide, you will learn how to use Terraform to deploy and expose a NGINX 
instance on a Kubernetes cluster.


## Prerequisites

An existing Kubernetes cluster is required for this guide. There are multiple 
ways to accomplish this:

-	Setting up a Kubernetes Cluster in AWS (AKS - link to Learn guide)
-	Setting up a Kubernetes Cluster in Azure (link to Learn guide)
-	Setting up a Kubernetes Cluster in GCP (GKE - link to Learn guide)
-	Local Install – minikube (link to Minikube install)

> **Online tutorial:** An interactive tutorial is also available if you do not 
have a Kubernetes cluster and do not want to set one up on a cloud provider or 
locally to perform the steps described in this guide.

<KatacodaEmbed
  scenarioId="im2nguyen/terraform-kubernetes-provider"
  brand="terraform"
  panel
  forceScenarioContentMode
  scenarioOptions={{
    color: '#000',
    secondary: '#333'
  }}
/>

## Provider Configuration

The following section applies configuring a generic Kubernetes cluster. 
For cloud specific configuration, please visit the following links:

-	Provider configuration in AWS
-	Provider configuration in Azure
-	Provider configuration in GCP

The easiest way to configure the provider is by creating/generating a config in 
a default location (`~/.kube/config`). That allows you to leave the provider 
block completely empty.

```hcl
provider "kubernetes" {}
```

### Manual Provider Configuration

Alternatively, you can manually provide these values in the provider 
configuration. If you are running minikube, you can view your Kubernetes 
configuration by running:

```text
$ cat ~/.kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /root/.minikube/ca.crt
    server: https://172.17.0.79:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /root/.minikube/client.crt
    client-key: /root/.minikube/client.key
```

These values can, then, be used to manually configure your provider. The 
following is a sample configuration using TLS configuration. Additional 
provider attributes can be found here.

```hcl
provider "kubernetes" {
  load_config_file = false

  host = "https://104.196.242.174"
  
  client_certificate     = file("~/.kube/.minikube/client.crt")
  client_key             = file("~/.kube/.minikube/client.key")
  cluster_ca_certificate = file("~/.kube/.minikube/ca.crt")
}
```

After specifying the provider, run `terraform init` to download the latest 
version and configure the Kubernetes provider.

## Deploying NGINX on Kubernetes Cluster

There are three methods to deploy your applications (pod) on a Kubernetes 
cluster. Each method has a specific use case and helps you maintain your 
application’s overall availability and stability.

1.	**Deployments** – Commonly used to deploy stateless applications. 
Deployments manages ReplicaSets, which in turn, create Pods. A Persistent 
Volume Claim (PVC) can be attached to deployments allowing pods of a deployment 
to access and share the same data.

1.	**StatefulSets** – Used to manage stateful applications. Each pod will 
create and access its own PVC. Since StatefulSets do not manage ReplicaSets, 
you cannot rollback to a previous version.

1.	**DaemonSets** – Used to ensure a pod runs on all nodes of the cluster. 
This can be useful for a logging or monitoring application.

The following Terraform snippet will deploy two instances (replicas = 2) of a 
ngnix web server, exposing port 80 (HTTP).

```hcl
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "scalable-nginx-example"
    labels = {
      App = "ScalableNginxExample"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "ScalableNginxExample"
      }
    }
    template {
      metadata {
        labels = {
          App = "ScalableNginxExample"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "example"

          port {
            container_port = 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}
```

To schedule the NGINX deployment, run: 

```bash
$ terraform apply
```

You may notice the similarities between the Terraform snippet and Kubernetes 
configuration [YAML file](https://kubernetes.io/docs/concepts/overview/working-with-objects/kubernetes-objects/).

Common deployment attributes like CPU and memory are present, allowing you to 
specify how much resources to allocate to a single instance of the NGNIX 
Deployment. This is incredibly helpful for Kubernetes as it helps avoiding 
under-provisioning or over-provisioning that would result in either unused 
resources (costing money) or lack of resources (causing the app to crash or 
slow down).

## Exposing NGINX instance via Service

To expose the NGINX instance to users, you need to schedule a Kubernetes Service.

Note how the Kubernetes Service resource block dynamically assigns the selector 
to the Deployment’s label. This mitigates common bugs due to mismatched service 
label selectors.

If you are using Katacoda or running Minikube locally, use the following snippet:

```hcl
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
```

To schedule the NodePort Service, run: 

```bash
$ terraform apply
```

Once the apply is complete, you can verify the service is up by accessing the 
Kubernetes UI to check both the deployment and the service there once they're 
scheduled.

You can also access the NGINX instance by navigating the NodePort (30201). 

### Exposing LoadBalancer LoadBalancer (for K8S in the cloud)


If your Kubernetes cluster is running on a cloud provider, use the following 
snippet instead:

```hcl
resource "kubernetes_service" "nginx" {
  metadata {
    name = "nginx-example"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
```

This creates a LoadBalancer instead of a NodePort Service, which routes traffic 
from the external load balancer to pods with the matching selector. You can 
expose NodePorts to external users too, however, this requires additional 
resources (e.g. Ingress, Firewall Rules) that are not within the scope of this 
guide.

You may also add an output which will expose the IP address to the user.

If you are using a cloud provider provisioning IP-based load balancers (e.g. Google Cloud Platform), 
you should use the following snippet:

```hcl
output "lb_ip" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].ip
}
```

If you are using a cloud provider with hostname-based load balancers (e.g. Amazon Web Services),
you should use the following snippet instead:

```hcl
output "lb_ip" {
  value = kubernetes_service.nginx.load_balancer_ingress[0].hostname
}
```

To schedule the LoadBalancer service, run: 

```bash
$ terraform apply
```

Once the apply is complete, you can verify the service is up by accessing the 
Kubernetes UI to check both the deployment and the service there once they're 
scheduled.

You can also access the NGINX instance by navigating to the `lb_ip` output. 

## Update Configuration

As our application user base grows, you may need more instances to be scheduled. 
The easiest way to achieve this is to increase replicas field in the config 
accordingly.

```hcl
resource "kubernetes_deployment" "nginx" {
# ...

  spec {
    replicas = 4

# ...

}
```

You can verify before hitting the API that you're only changing what you 
intended to change and that someone else didn't modify the resource you created 
earlier.

```text
$ terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but will not be
persisted to local or remote state storage.

kubernetes_deployment.nginx: Refreshing state... (ID: default/scalable-nginx-example)
kubernetes_service.nginx: Refreshing state... (ID: default/nginx-example)

The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

  ~ kubernetes_deployment.nginx
      spec.0.replicas: "2" => "4"

Plan: 0 to add, 1 to change, 0 to destroy.
```

Apply the change then navigate to the Kubernetes UI to confirm a total of 5 
replicas are scheduled.

```
$ terraform apply
```

If you are successful, you should see something like this:

![new k8s deployments](/img/terraform/kubernetes/k8s-change-deployments.png)

## Next Steps

To discover additional capabilities, visit the [Terraform Kubernetes Provider Registry Documentation Page](https://registry.terraform.io/providers/hashicorp/kubernetes/1.11.0/docs).
