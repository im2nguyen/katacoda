## Overview of Workspace

This is the workspace for **Get Started with the Terraform Kubernetes Provider**.

This workspace contains a minikube instance and preconfigured `kubectl`.

## Manual Provider Configuration
To view your Kubernetes configuration, run:

`cat ~/.kube/config`{{execute}}

These values can, then, be used to manually configure your provider. The 
following is a sample configuration using TLS configuration. Replace 
`HOST_NAME_HERE` with the corresponding value from the above command.

<pre class="file" data-filename="main.tf" data-target="replace">
provider "kubernetes" {
  load_config_file = "false"

  host = "HOST_NAME_HERE"
  
  # Configured for Katacoda Minikube
  client_certificate     = file("~/.minikube/client.crt")
  client_key             = file("~/.minikube/client.key")
  cluster_ca_certificate = file("~/.minikube/ca.crt")
}
</pre>

To initialize Terraform, run `terraform init`{{execute}}. This will download and configure
the Terraform Kubernetes Provider.

## Deploying NGINX on Kubernetes Cluster 

<pre class="file" data-filename="main.tf" data-target="append">
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

</pre>

To schedule the NGINX deployment, run: 
`terraform apply`{{execute}}


## Deploying NGINX on Kubernetes Cluster 

<pre class="file" data-filename="main.tf" data-target="append">
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

</pre>

To schedule the NodePort Service, run: 
`terraform apply`{{execute}}
