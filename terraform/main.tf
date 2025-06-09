terraform {

  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
  }

}


provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "main" {
  name    = "gitlab-cluster"
  region  = "fra1"
  version = "latest"

  node_pool {
    name       = "default-pool"
    size       = "s-2vcpu-2gb"
    node_count = 1
  }
}

#resource "digitalocean_record" "wildcard_auto" {
#  domain = "do.t3isp.de"
#  type   = "A"
#  name   = "auto"
#  value  = digitalocean_kubernetes_cluster.main.endpoint
#  ttl    = 60
#}
