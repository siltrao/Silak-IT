# Architecture réseau — Silak-IT

## Vue d'ensemble
Infrastructure virtualisée sous Proxmox, avec un routeur central (vm-router) assurant le NAT, le routage inter-VLAN et le filtrage (nftables) entre les VLAN dédiés, chacun correspondant à un niveau de sensibilité et un usage métier distinct.

## VLAN et VM associées

| VLAN | Nom | IP réseau | VM/CT | Rôle |
|---|---|---|---|---|
| 10 | Administration | 192.168.10.0/24 | vm-ldap *(prévue, non déployée)* | Annuaire LDAP centralisé pour l'authentification des administrateurs |
| 20 | Web | 192.168.20.0/24 | vm-web | Apache/PHP |
| 30 | Base SQL | 192.168.30.0/24 | vm-db | MariaDB |
| 40 | Monitoring | 192.168.40.0/24 | vm-monitoring | Prometheus, Grafana, Alertmanager, Node Exporter (via Docker) |
| 50 | IA / SOC | 192.168.50.0/24 | vm-ai, vm-soc | Ollama (Silak Assistant), Wazuh |
| 60 | Payroll | 192.168.60.0/24 | vm-payroll | Logiciel de paie (isolé) |

## Administration et exploitation
Un conteneur LXC dédié (vm-devops) héberge les outils d'Infrastructure as Code : Terraform, Ansible, Git — point d'entrée unique pour reconstruire l'ensemble de l'infrastructure. Il dispose d'un accès réseau vers tous les VLAN pour l'exécution des playbooks Ansible.

## Passerelle et accès externe
vm-router expose une interface WAN (192.168.1.186) connectée au réseau physique de l'hôte, et une interface trunk (vmbr1) distribuant l'ensemble des VLAN via 802.1Q. C'est l'unique point d'entrée/sortie de l'infrastructure Silak-IT vers l'extérieur.

## Principe de segmentation
Chaque VLAN correspond à un niveau de sensibilité différent, avec un filtrage réseau strict entre eux (nftables sur vm-router) :
- Le VLAN Payroll (60) est le plus isolé, sans accès direct depuis les autres VLAN sauf flux strictement nécessaires
- Le VLAN Monitoring (40) doit pouvoir scraper les autres VLAN (Node Exporter) sans que l'inverse soit vrai
- Le VLAN IA/SOC (50) doit pouvoir interroger le VLAN Monitoring (Prometheus) pour Silak Assistant

## Contraintes de ressources
L'ensemble de l'infrastructure est hébergée sur un environnement de virtualisation imbriquée (Proxmox dans VirtualBox), avec 16 Go de RAM physique disponible au total — ce qui impose un dimensionnement mémoire ajusté par VM/CT plutôt que des valeurs par défaut.
