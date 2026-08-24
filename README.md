cat > README.md << 'EOF'
# Silak-IT

**Une offre packagée B2B d'infrastructure sécurisée et automatisée, augmentée d'un assistant IA d'exploitation.**

Silak-IT est un produit conçu et développé par [Teka.com](https://teka.com), entreprise spécialisée depuis deux décennies dans l'installation réseau et le déploiement d'infrastructures télécom. Ce dépôt contient l'ensemble du code source du produit : infrastructure as code, automatisation, et l'assistant intelligent qui l'accompagne.

> Projet réalisé dans le cadre d'un Mastère Ingénieur Systèmes, Réseaux et Cybersécurité (Titre RNCP 38105), en alternance chez Teka.com.

---

## Le produit

Silak-IT s'adresse aux PME et ESN ne disposant pas des ressources internes pour déployer et exploiter une infrastructure informatique complète. Il combine deux briques indissociables :

- **Une infrastructure automatisée** — provisioning, configuration, supervision et cybersécurité, entièrement pilotés par code (Terraform, Ansible)
- **Silak Assistant** — un assistant IA local, capable d'interagir en langage naturel avec cette infrastructure pour en faciliter l'exploitation quotidienne

### Les quatre piliers de l'offre

| Pilier | Description |
|---|---|
| Infrastructure automatisée | Provisioning et configuration reproductibles (Terraform, Ansible) |
| Sécurité renforcée | Segmentation réseau, durcissement, détection d'intrusion (SOC) |
| Supervision continue | Visibilité en temps réel sur l'état du parc (Prometheus, Grafana) |
| Exploitation assistée par IA | Interaction en langage naturel avec l'infrastructure (Silak Assistant) |

---

## Architecture

L'infrastructure repose sur Proxmox, segmentée en **9 VLAN** selon le niveau de sensibilité de chaque service :

| VLAN | Nom | Rôle |
|---|---|---|
| 10 | Administration | Annuaire LDAP, poste IaC, runner CI/CD |
| 20 | Web / DMZ | Application web exposée |
| 30 | Base SQL | Base de données (PostgreSQL) |
| 40 | Monitoring | Prometheus, Grafana, Alertmanager |
| 50 | IA | Silak Assistant (Ollama) |
| 60 | Payroll | Logiciel de paie — isolement strict |
| 70 | SOC | Wazuh — détection de sécurité |
| 80 | RH | Accès limité à l'application de paie |
| 90 | Users | Accès limité au service web |

L'accès à l'infrastructure suit un modèle de bastion strict : toute administration transite par `vm-devops`, aucune VM métier n'étant directement exposée.

---

## Silak Assistant

L'élément différenciant du produit : un assistant IA exécuté localement (Ollama / Llama 3.2), sans dépendance à une API cloud externe, structuré en trois volets :

- **Savoir** — répond aux questions sur l'architecture et la configuration de l'infrastructure (RAG sur la documentation technique)
- **Voir** — restitue l'état de santé de l'infrastructure en temps réel (interrogation de Prometheus)
- **Veiller** — surveille les signaux de sécurité et les tentatives d'intrusion (fail2ban)

Le code source de l'assistant se trouve dans [`silak-assistant/`](./silak-assistant).

---

## Sécurité

- Segmentation réseau stricte, filtrage nftables, authentification SSH par clés, fail2ban
- VPN WireGuard avec profils d'accès différenciés (administrateur, RH, utilisateur)
- Vérification d'intégrité des images système (empreinte SHA-256) avant tout déploiement
- Pipeline CI (GitHub Actions, runner auto-hébergé isolé) validant le code avant application
- SOC (Wazuh) — détection validée par simulation d'attaque réelle, classification MITRE ATT&CK

Le détail complet est documenté dans [`docs/cybersecurite/`](./docs/cybersecurite).

---

## Structure du dépôt
