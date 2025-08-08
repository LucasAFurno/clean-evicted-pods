#!/bin/bash
# Name: clean-evicted-pods.sh
# Author: Lucas Furno
# Description: Deletes all Evicted pods across all namespaces in Kubernetes

echo "🔍 Searching for Evicted pods..."
pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Failed \
  | grep Evicted | awk '{print $1, $2}')

if [ -z "$pods" ]; then
  echo "✅ No Evicted pods found."
  exit 0
fi

echo "$pods" | while read namespace pod; do
  echo "🗑️  Deleting pod $pod in namespace $namespace..."
  kubectl delete pod "$pod" -n "$namespace"
done

echo "🎯 Cleanup complete."
