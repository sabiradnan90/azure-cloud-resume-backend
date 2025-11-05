# Azure Cloud Resume Backend


This repo auto-provisions a visitor API and static site hosting on Azure with a single push.


## Setup


1. Install prerequisites: `az` CLI, `terraform`, `zip`, `python3`
2. Create a service principal and add as GitHub secret `AZURE_CREDENTIALS`:


```bash
az ad sp create-for-rbac --sdk-auth --role Contributor --scopes /subscriptions/<subscription-id>