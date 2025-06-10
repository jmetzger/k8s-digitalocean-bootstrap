variable "do_token" {
  description = "DigitalOcean access token"
  type        = string
  sensitive   = true
}

variable "k8s_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.31.1-do.4"
}
