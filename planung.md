# Projekt: Kubernetes Cluster Bootstrap auf DigitalOcean mit GitLab CI/CD

## Ziel
Dieses Projekt automatisiert die Bereitstellung eines 1-Node-Kubernetes-Clusters auf DigitalOcean inkl. Ingress-Controller, Let's Encrypt TLS und Testservice.

## Infrastruktur
- Terraform erstellt einen Kubernetes-Cluster in FRA1 (1 Node)
- Helm installiert den ingress-nginx Controller im Namespace `ingress-nginx`
- Helm installiert cert-manager im Namespace `cert-manager`
- Ein Wildcard-DNS-Eintrag `*.auto.do.t3isp.de` wird über einen A-Record auf den LoadBalancer gezeigt
- Eine Test-App wird über `test.auto.do.t3isp.de` erreichbar gemacht und automatisch TLS-gesichert

## Schritte
1. Terraform init/apply
2. Helm: Ingress-Controller, cert-manager, Test-App
3. Manuelles `terraform destroy` via CI


## Sicherheitshinweis: GitLab API Token

Für den Upload der kubeconfig wird ein Personal Access Token (PAT) benötigt:

- Der PAT ist **benutzerweit gültig**, nicht projektspezifisch.
- Er benötigt den Scope: `api`
- Er wird als GitLab CI/CD Variable `GITLAB_PAT_KUBECONFIG` gespeichert

**Empfehlung:** Wenn möglich, verwende einen separaten GitLab-Benutzer mit nur Projektzugriff oder ein Projekt-Access-Token (nur Premium).

## Schritte zum Einrichten des GitLab-Repos

1. Repository in GitLab anlegen (z. B. `k8s-digitalocean-bootstrap`)
2. ZIP-Datei lokal entpacken und ins Repo pushen:
   ```bash
   unzip k8s-digitalocean-bootstrap-tls-upload.zip
   cd k8s-digitalocean-bootstrap
   git init
   git remote add origin https://gitlab.com/<username>/k8s-digitalocean-bootstrap.git
   git checkout -b main
   git add .
   git commit -m "Initial commit"
   git push -u origin main
   ```

3. GitLab CI/CD Variables unter `Settings → CI/CD → Variables` hinzufügen:

   | Name                   | Wert                          | Type   |
   |------------------------|-------------------------------|--------|
   | DIGITALOCEAN_TOKEN     | Dein DO API Token             | Secret |
   | GITLAB_PAT_KUBECONFIG  | Dein GitLab Personal Token    | Secret |

4. Pipeline startet automatisch (`terraform`, `helm`)
5. Optional: `upload-kubeconfig` manuell auslösen

