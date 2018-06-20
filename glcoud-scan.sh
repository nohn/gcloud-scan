#!/usr/bin/env bash

SCANFOR="$1"

declare -A SCOPES=(
    [sshkeys]="compute project-info describe"
    [instances]="compute instances list"
    [service-accounts]="iam service-accounts list"
)

# Iterate over all projects
for PROJECT in $(gcloud projects list --format="value(projectId)" | sort); do
    echo "Scanning Project $PROJECT..."
    echo " for IAM Users..."
    gcloud projects get-iam-policy "$PROJECT" | grep "$SCANFOR" | sort
    # Iterate over all scopes
    for SCOPE in "${!SCOPES[@]}"; do
	echo " for $SCOPE..."
	gcloud ${SCOPES[$SCOPE]} --project="$PROJECT" | grep "$SCANFOR" | sort
    done
    echo; echo
done
