#!/usr/bin/env bash
set -euo pipefail

location="${AZURE_LOCATION:-westeurope}"

subscriptions=(
  "3126b4c2-cba4-40e9-9d3d-a3b031cdea56"
  "d677493f-c5e8-48f1-b230-b3acdb23c4af"
  "2414a5eb-8d32-44ae-b78e-ba08e97e5ddf"
  "ffa00009-3df1-41db-9431-1c1dc4cb8202"
  "6a34a98f-9e57-4e8c-848a-5113fed27fac"
  "0ffe4d2b-73d8-4d1b-ae76-90125d020ec6"
  "40fa9942-c131-4ba7-8031-ea4153aa0720"
  "f531edbe-0998-40e3-a565-dd277abd1afe"
  "537e43c3-48e9-44cd-af3c-58ac788b1e0f"
  "eccbb47e-a076-42ef-adec-7718612dd629"
)

for i in "${!subscriptions[@]}"; do
  index=$(printf "%02d" "$((i + 1))")
  subscription_id="${subscriptions[$i]}"
  resource_group_name="rg-shell-smoke-$(date +%Y%m%d%H%M%S)-${index}"

  echo "Processing subscription ${index}: ${subscription_id}"
  az account set --subscription "$subscription_id"

  echo "Creating ${resource_group_name} in ${location}"
  az group create \
    --name "$resource_group_name" \
    --location "$location" \
    --tags purpose=shell-smoke \
    --output none

  echo "Deleting ${resource_group_name}"
  az group delete \
    --name "$resource_group_name" \
    --yes \
    --output none

  az group wait \
    --name "$resource_group_name" \
    --deleted \
    --interval 10 \
    --timeout 900
done

echo "Done"