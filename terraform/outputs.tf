output "ingress_domain" {
  value = "app.t3isp.de"
}

output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.main.kube_config[0].raw_config
  sensitive = true
}

