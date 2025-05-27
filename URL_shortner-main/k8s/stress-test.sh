#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to print section headers
print_header() {
    echo -e "\n${GREEN}=== $1 ===${NC}\n"
}

# Get the service URL
SERVICE_URL=$(minikube service url-shortener --url)
echo -e "${YELLOW}Service URL: $SERVICE_URL${NC}"

# Show initial state
print_header "Initial State"
echo "Current pod count:"
kubectl get pods -l app=url-shortener | wc -l

echo -e "\nHPA status:"
kubectl get hpa

# Run stress test
print_header "Running Stress Test"
echo "Starting stress test with 1000 requests and 100 concurrent connections..."
hey -n 1000 -c 100 $SERVICE_URL

# Wait for HPA to adjust
print_header "Waiting for HPA to adjust..."
sleep 30

# Show final state
print_header "Final State"
echo "Final pod count:"
kubectl get pods -l app=url-shortener | wc -l

echo -e "\nHPA status:"
kubectl get hpa

# Show pod logs
print_header "Pod Logs"
for pod in $(kubectl get pods -l app=url-shortener -o jsonpath='{.items[*].metadata.name}'); do
    echo -e "\n${YELLOW}Logs for pod: $pod${NC}"
    kubectl logs $pod --tail=50
done

# Show resource usage
print_header "Resource Usage"
kubectl top pods -l app=url-shortener 