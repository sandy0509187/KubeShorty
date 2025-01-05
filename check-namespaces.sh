#!/bin/sh

# Get current date
current_date=$(date +%s)

# Loop through namespaces with the label "env=dev"
kubectl get ns --selector=env=dev -o json | jq -r '.items[] | .metadata.name' | while read ns; do
  # Get the creation timestamp of the namespace
  creation_date=$(kubectl get ns $ns -o json | jq -r '.metadata.creationTimestamp')
  
  # Convert creation date to seconds since epoch
  creation_seconds=$(date -d "$creation_date" +%s)
  
  # Calculate the age of the namespace in days
  age_days=$(( (current_date - creation_seconds) / 86400 ))
  
  # If namespace is older than 5 days, delete it
  if [ "$age_days" -ge 5 ]; then
    echo "Namespace $ns is $age_days days old, deleting..."
    kubectl delete ns $ns
  fi

  # If namespace is 4 years or older, send a Slack notification
  if [ "$age_days" -ge 1460 ]; then
    message="Warning: Namespace $ns is $age_days days old (4 years or more)"
    #curl -X POST -H 'Content-type: application/json' --data '{"text": "'"$message"'"}' $SLACK_WEBHOOK_URL
  fi
done
