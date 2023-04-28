echo "my name is $NAMESPACE"
# #!/bin/bash

# set -e

# function get_vault_version() {
#   local vault_address="$1"
#   local vault_health_json

#   vault_health_json=$(curl -s "$vault_address/v1/sys/health")

#   local vault_version
#   vault_version=$(echo "$vault_health_json" | jq -r '.version')

#   echo "$vault_version"
# }

# function patch_vault_update_strategy() {
#   echo "Patching Vault statefulset update strategy to OnDelete..."
#   kubectl patch statefulset vault -p '{"spec":{"updateStrategy":{"type":"OnDelete"}}}'
# }

# function patch_vault_container_image() {
#   if [ -z "$VAULT_IMAGE" ]; then
#     echo "Error: VAULT_IMAGE environment variable is not set."
#     exit 1
#   fi

#   echo "Patching Vault container image to $VAULT_IMAGE..."
#   kubectl get statefulset vault -o json | \
#   jq --arg img "$VAULT_IMAGE" '(.spec.template.spec.containers[] | select(.name == "vault").image) |= $img | del(.metadata.resourceVersion, .metadata.uid, .metadata.creationTimestamp, .metadata.generation, .status)' > vault_patched.json

#   kubectl apply -f vault_patched.json
#   rm vault_patched.json
# }

# function delete_pods_by_selector() {
#   local selector="$1"
#   local pods_to_delete=$(kubectl get pods --selector="$selector" -o jsonpath='{.items[*].metadata.name}')

#   echo "Deleting pods with selector \"$selector\" and waiting for the Vault container to be functional before deleting the next pod..."
#   for pod in $pods_to_delete; do
#     echo "Deleting pod $pod"
#     kubectl delete pod $pod

#     echo "Pod deleted, waiting for the new pod to be ready..."
#     timeout_counter=0
#     while true; do
#       pod_status=$(kubectl get pod $pod -o jsonpath='{.status.phase}')
#       pod_ready=$(kubectl get pod $pod -o jsonpath='{.status.containerStatuses[?(@.name=="vault")].ready}')

#       if [[ "$pod_status" == "Running" ]] && [[ "$pod_ready" == "true" ]]; then
#         echo "Pod is running and ready"
#         break
#       elif [[ $timeout_counter -ge 300 ]]; then
#         echo "Timeout: Pod is not ready after 5 minutes"
#         exit 1
#       else
#         sleep 1
#         timeout_counter=$((timeout_counter + 1))
#       fi
#     done
#   done
# }

# patch_vault_update_strategy
# patch_vault_container_image
# delete_pods_by_selector "vault-active=false"
# delete_pods_by_selector "vault-active=true"

# echo "All tasks completed."
