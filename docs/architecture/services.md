# Services par VM/CT — Silak-IT

## vm-ldap (VLAN 10)
Annuaire OpenLDAP centralisant les comptes administrateurs. Intégration SSSD sur les autres VM pour l'authentification SSH centralisée, plutôt que des comptes locaux dupliqués.

## vm-web (VLAN 20)
Serveur Apache2 avec PHP, hébergeant l'application web de démonstration de Silak-IT (VirtualHost dédié).

## vm-db (VLAN 30)
Serveur MariaDB, avec utilisateurs et bases dédiés par application, accès restreint au VLAN Web et à vm-devops pour l'administration.

## vm-monitoring (VLAN 40)
Stack de supervision conteneurisée (Docker) : Prometheus (collecte de métriques), Grafana (visualisation), Alertmanager (gestion des alertes), Node Exporter déployé sur chaque VM pour l'exposition des métriques système.

## vm-ai (VLAN 50)
Silak Assistant : moteur Ollama (modèle Llama 3.2 3B) exposant une interface web Streamlit. Interroge la documentation interne du projet (recherche par mots-clés) et l'API Prometheus pour répondre sur l'état de l'infrastructure en langage naturel.

## vm-soc (VLAN 50)
Wazuh (manager + indexer), réceptionnant les événements de sécurité des agents installés sur l'ensemble des VM du parc, avec tableau de bord dédié à l'analyse des incidents.

## vm-payroll (VLAN 60)
Logiciel métier de gestion de paie, isolé dans un VLAN dédié avec une politique de filtrage stricte, en raison de la sensibilité des données traitées.

## vm-devops (LXC, hors VLAN métier)
Outils d'Infrastructure as Code : Terraform (provisioning), Ansible (configuration), Git (versionnage) — point d'entrée unique pour reconstruire l'ensemble de l'infrastructure de façon reproductible.
