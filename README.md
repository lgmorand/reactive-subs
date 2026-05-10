# reactive-subs

Ce repository contient un workflow GitHub Actions qui effectue un test simple sur 10 subscriptions Azure:
1. se connecter avec un service principal,
2. créer un Resource Group,
3. supprimer ce Resource Group.

Le workflow se lance automatiquement une fois par mois.

## Workflow

Fichier: `.github/workflows/monthly-azure-rg-smoke.yml`

Declencheurs:
1. `schedule`: tous les 1ers du mois a 03:00 UTC
2. `workflow_dispatch`: execution manuelle depuis GitHub Actions

## Configuration requise

### Secrets GitHub Actions (service principal)

Ajouter ces secrets au niveau du repository:
1. `AZURE_TENANT_ID`
2. `AZURE_CLIENT_ID`
3. `AZURE_CLIENT_SECRET`

Le service principal doit avoir les permissions necessaires (minimum Contributor sur les subscriptions ciblees, ou scope adapte) pour creer/supprimer des Resource Groups.

### Variables GitHub Actions (10 subscriptions)

Ajouter ces variables au niveau du repository:
1. `AZ_SUBSCRIPTION_01`
2. `AZ_SUBSCRIPTION_02`
3. `AZ_SUBSCRIPTION_03`
4. `AZ_SUBSCRIPTION_04`
5. `AZ_SUBSCRIPTION_05`
6. `AZ_SUBSCRIPTION_06`
7. `AZ_SUBSCRIPTION_07`
8. `AZ_SUBSCRIPTION_08`
9. `AZ_SUBSCRIPTION_09`
10. `AZ_SUBSCRIPTION_10`

Variable optionnelle:
1. `AZURE_LOCATION` (par defaut: `westeurope`)

## Fonctionnement

Le job:
1. valide que les secrets et les 10 variables de subscription existent,
2. fait un `az login` avec le service principal,
3. boucle sur les 10 subscriptions,
4. cree un Resource Group temporaire nomme comme `rg-gha-smoke-<run_id>-<index>`,
5. supprime ce Resource Group,
6. attend la suppression effective,
7. se deconnecte (`az logout`).

## Lancer manuellement

Depuis GitHub:
1. ouvrir l'onglet Actions,
2. selectionner `Monthly Azure RG Smoke Test`,
3. cliquer sur `Run workflow`.

## Notes

1. Le cron GitHub Actions est en UTC.
2. La suppression d'un Resource Group peut prendre plusieurs minutes selon la subscription.
3. Ce workflow est volontairement minimaliste pour valider l'acces et l'action sur chaque subscription.