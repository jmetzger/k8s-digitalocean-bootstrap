# GitHub Actions Setup

## Required Secrets

Gehe zu deinem GitHub Repository → Settings → Secrets and variables → Actions und füge folgende Secrets hinzu:

### Repository Secrets
- `DIGITALOCEAN_ACCESS_TOKEN`: Dein DigitalOcean API Token

## Workflow Übersicht

Die GitHub Actions Pipeline besteht aus 3 Jobs:

### 1. terraform
- Erstellt die DigitalOcean Kubernetes Infrastruktur
- Speichert kubeconfig als Artifact

### 2. helm  
- Installiert Ingress-Nginx Controller
- Installiert Cert-Manager
- Wartet auf LoadBalancer IP
- Erstellt automatisch DNS-Record für `*.auto.do.t3isp.de`
- Deployed die Testapplikation

### 3. destroy (Manual)
- Kann nur manuell über "Run workflow" ausgeführt werden
- Zerstört die komplette Infrastruktur
- Verwendet GitHub Environment "destruction" für zusätzliche Sicherheit

## Verwendung

### Automatisches Deployment
- Push auf `main` Branch triggert automatisch das Deployment
- Oder manuell über "Actions" → "Deploy DigitalOcean Kubernetes" → "Run workflow"

### Manuelles Destroy
- Gehe zu Actions → "Deploy DigitalOcean Kubernetes" → "Run workflow"
- Der destroy Job wird nur bei manueller Ausführung gestartet

## Unterschiede zur GitLab CI

- **Artifacts**: Verwendet GitHub Actions artifacts statt GitLab artifacts
- **Secrets**: Verwendet GitHub Secrets statt GitLab CI/CD Variables  
- **Environment Protection**: Destroy Job ist durch GitHub Environment geschützt
- **Timeout Handling**: Robusteres Warten auf LoadBalancer IP mit Timeout
- **Workflow Dispatch**: Manueller Trigger möglich

## Nächste Schritte

1. Secrets im GitHub Repository konfigurieren
2. Workflow durch Push oder manuell starten
3. Nach erfolgreichem Deployment ist die App verfügbar unter: `https://test.auto.do.t3isp.de`