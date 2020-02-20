## Localhost substitution

NOTE: If you are using Katacoda, Katacoda routes services using the following template:

`https://[[HOST_SUBDOMAIN]]-[[PORT]]-[[KATACODA_HOST]].environments.katacoda.com`

As a result, you should substitute any references to localhost to the following:

| Learn Address   | Katacoda Address |
| --------------  | ---------------- |
| localhost:8500  | [[HOST_SUBDOMAIN]]-8500-[[KATACODA_HOST]].environments.katacoda.com |
| localhost:9001  | [[HOST_SUBDOMAIN]]-9001-[[KATACODA_HOST]].environments.katacoda.com |
| localhost:8080  | [[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com |

Your `main.tf` file should be similar to:

<pre class="file" data-filename="main.tf" data-target="replace"># Configure the Consul provider
provider "consul" {
  address    = "[[HOST_SUBDOMAIN]]-8500-[[KATACODA_HOST]].environments.katacoda.com"
  datacenter = "dc1"
  token      = "254cbfc6-cf26-7a60-4d40-c9b06af9ab75"
}

# Register Consul Node - counting
resource "consul_node" "counting" {
  name    = "counting"
  address = "[[HOST_SUBDOMAIN]]-9001-[[KATACODA_HOST]].environments.katacoda.com"
}

# Register Consul Node - dashboard
resource "consul_node" "dashboard" {
  name    = "dashboard"
  address = "[[HOST_SUBDOMAIN]]-8080-[[KATACODA_HOST]].environments.katacoda.com"
}
</pre>