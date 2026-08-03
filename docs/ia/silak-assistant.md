# Silak Assistant — Documentation fonctionnelle

## Présentation
Silak Assistant est l'interface intelligente de l'infrastructure Silak-IT. Ce n'est pas un simple chatbot générique : il s'appuie sur les données réelles de l'infrastructure (supervision, documentation technique, événements de sécurité) pour répondre aux administrateurs et techniciens.

## Public cible
Administrateurs systèmes, techniciens et utilisateurs de Silak-IT souhaitant obtenir rapidement des informations sur l'infrastructure, sans devoir chercher manuellement dans plusieurs outils (Grafana, documentation, terminaux SSH).

## Architecture technique
- **Moteur d'inférence** : Ollama, modèle Llama 3.2 3B, exécuté localement sur vm-ai (VLAN 50) — aucune dépendance à une API cloud externe, garantissant la confidentialité des données de l'infrastructure.
- **Interface** : application web Streamlit, accessible via navigateur, offrant une expérience de type chat.
- **Sources de données** :
  - Documentation interne du projet (`docs/`) et README des rôles Ansible, consultés par recherche de mots-clés pour contextualiser les réponses.
  - API Prometheus (vm-monitoring, VLAN 40), interrogée à la demande pour fournir un état actualisé de l'infrastructure (charge, disponibilité des services).

## Fonctionnalités (périmètre actuel)
1. **Assistant documentaire** : répond aux questions sur l'architecture, les rôles Ansible, la configuration des services, à partir de la documentation du projet.
2. **Assistant d'exploitation** : interroge les métriques Prometheus en langage naturel (ex. « quel est l'état de vm-web ? ») et restitue une réponse compréhensible sans requête PromQL manuelle.

## Perspectives d'évolution
- **Assistant cybersécurité** : intégration avec Wazuh pour résumer les incidents de sécurité et proposer des pistes de remédiation.
- **Assistant DevOps** : génération assistée de manifestes Terraform/Ansible à partir de demandes en langage naturel.

## Valeur ajoutée
Contrairement à un assistant IA générique, Silak Assistant est ancré dans les données réelles et évolutives de l'infrastructure qu'il sert, ce qui en fait un outil d'exploitation à part entière plutôt qu'un simple gadget conversationnel.
