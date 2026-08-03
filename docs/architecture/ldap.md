# Annuaire LDAP — Silak-IT

## Présentation
OpenLDAP centralise l'authentification des comptes administrateurs sur l'ensemble du parc Silak-IT, en remplacement de comptes locaux dupliqués sur chaque VM/CT.

## Emplacement
VLAN 10 (Administration), IP réseau 192.168.10.0/24 — isolé des VLAN de production (Web, Base SQL, Payroll), accessible uniquement aux flux d'authentification et d'administration.

## Schéma d'annuaire
- **Organisation** : `dc=silak-it,dc=local`
- **Unités organisationnelles** : `ou=admins` (comptes administrateurs système), `ou=groups` (groupes de droits : sudo, ansible, monitoring)
- **Comptes gérés** : comptes nominatifs des administrateurs, avec appartenance aux groupes définissant leurs droits sur chaque VM

## Intégration côté clients
Chaque VM/CT du parc (vm-web, vm-db, vm-monitoring, vm-ai, vm-soc, vm-devops) est configurée avec SSSD pour déléguer l'authentification SSH à l'annuaire LDAP central, plutôt que de gérer des comptes locaux indépendants.

## Politique de sécurité associée
- Complexité et expiration des mots de passe imposées au niveau de l'annuaire
- Authentification par clé SSH conservée en complément pour les comptes de service (Ansible, Terraform)
- Révocation immédiate d'un compte compromis depuis un point central, sans intervention sur chaque machine individuellement

## Valeur ajoutée pour la gestion de l'infrastructure
La centralisation LDAP réduit la surface d'attaque liée à des comptes locaux oubliés ou mal synchronisés, et s'inscrit dans la politique de sécurité globale de Silak-IT aux côtés de la segmentation VLAN et du filtrage nftables.
