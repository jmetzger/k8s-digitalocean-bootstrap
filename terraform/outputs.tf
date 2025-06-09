output "ingress_domain" {
  value = "auto.do.t3isp.de"
}

output "kubeconfig" {
  value     = digitalocean_kubernetes_cluster.main.kube_configs[0].raw_config
  sensitive = true
}

