# Silak-IT — Projet de Fin de Formation

**Conception et déploiement d'une plateforme intelligente d'administration et de cybersécurité pour l'entreprise Silak-IT**

Projet de fin de formation Ingénieur Systèmes Réseaux et Cybersécurité, mettant en œuvre une infrastructure complète (Infrastructure as Code, supervision, cybersécurité) enrichie par **Silak Assistant**, un assistant IA local d'exploitation.

## Contexte

Silak-IT est une entreprise fictive (ESN) servant de fil conducteur pédagogique au projet. L'objectif est de concevoir une infrastructure réseau segmentée, automatisée et supervisée, intégrant un assistant intelligent capable d'interagir avec cette infrastructure en langage naturel.

## Architecture cible

Infrastructure virtualisée sous Proxmox, organisée en 6 VLAN dédiés, chacun correspondant à un niveau de sensibilité et un usage métier distinct :

| VLAN | Nom | VM/CT | Rôle |
|---|---|---|---|
| 10 | Administration | vm-ldap | Annuaire LDAP centralisé |
| 20 | Web | vm-web | Apache/PHP |
| 30 | Base SQL | vm-db | MariaDB |
| 40 | Monitoring | vm-monitoring | Prometheus, Grafana, Alertmanager |
| 50 | IA / SOC | vm-ai, vm-soc | Silak Assistant (Ollama), Wazuh |
| 60 | Payroll | vm-payroll | Logiciel de paie (isolé) |

Un conteneur LXC dédié (`vm-devops`) héberge les outils d'Infrastructure as Code (Terraform, Ansible, Git), point d'entrée unique pour reconstruire l'ensemble de l'infrastructure.

Détails complets : [`docs/architecture/`](docs/architecture/) · [`docs/cybersecurite/`](docs/cybersecurite/)

## Silak Assistant

Assistant IA local (Ollama, modèle Llama 3.2 3B), exposé via une interface web Streamlit, capable de :
- Répondre aux questions sur l'architecture et la configuration du projet
- Interroger l'état de l'infrastructure en langage naturel via Prometheus

Silak Assistant s'appuie sur les données réelles de l'infrastructure plutôt que sur un simple LLM générique — c'est l'interface intelligente de Silak-IT.

Documentation détaillée : [`docs/ia/silak-assistant.md`](docs/ia/silak-assistant.md)

## Feuille de route de mise en œuvre

| Phase | Contenu |
|---|---|
| 1 | Infrastructure réseau (routeur, VLAN, filtrage) |
| 2 | Provisioning des VM (Terraform) |
| 3 | Automatisation de la configuration (Ansible) |
| 4 | Durcissement sécurité (SSH par clés, nftables) |
| 5 | Supervision (Prometheus, Grafana) |
| 6 | SOC (Wazuh) |
| 7 | Silak Assistant (IA) |
| 8 | Intégration CI/CD |

## Structure du dépôt
## Déploiement

```bash
git clone https://github.com/siltrao/Silak-IT.git
cd Silak-IT/terraform
terraform init
terraform apply

cd ../ansible
ansible-playbook -i inventory/hosts.yml playbooks/monitoring.yml
```

## Sécurité

Segmentation VLAN stricte, authentification SSH par clés, annuaire LDAP centralisé, supervision de sécurité via Wazuh.
