0~# Durcissement sécurité — Silak-IT

## Authentification SSH par clés
L'ensemble des VM/CT du projet est configuré pour privilégier l'authentification par clé publique (ED25519) plutôt que par mot de passe, réduisant l'exposition aux attaques par force brute. Les clés sont injectées automatiquement à la création via cloud-init pour les VM provisionnées par Terraform.

## Segmentation réseau par VLAN
Chaque service métier est isolé dans son propre VLAN (Web, Base SQL, Monitoring, IA/SOC, Payroll, Administration), avec un filtrage nftables strict sur vm-router limitant les flux inter-VLAN au strict nécessaire (principe du moindre privilège réseau).

## Isolation du VLAN Payroll
Le VLAN 60 (Payroll), hébergeant les données de paie, est le plus cloisonné de l'architecture : aucun flux entrant n'est autorisé depuis les autres VLAN sauf ceux explicitement nécessaires à l'exploitation (sauvegarde, supervision minimale).

## Supervision de sécurité (SOC)
Wazuh centralise les événements de sécurité de l'ensemble du parc via des agents déployés sur chaque VM, permettant la détection d'anomalies, la remontée d'alertes et une visibilité transverse sur l'état de sécurité de l'infrastructure.

## Centralisation des identités
Un annuaire LDAP (vm-ldap, VLAN 10) centralise les comptes administrateurs, évitant la dispersion de comptes locaux sur chaque machine et facilitant la révocation immédiate d'un accès compromis.

## Infrastructure as Code
L'ensemble de l'infrastructure étant définie en Terraform et Ansible, toute dérive de configuration (drift) peut être détectée et corrigée en réappliquant les manifestes, plutôt que par des interventions manuelles risquant d'introduire des incohérences.
