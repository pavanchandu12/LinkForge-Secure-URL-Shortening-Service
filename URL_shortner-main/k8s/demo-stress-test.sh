#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print section headers
print_header() {
    echo -e "\n${GREEN}=== $1 ===${NC}\n"
}

# Get the NodePort
NODE_PORT=$(kubectl get service url-shortener -o jsonpath='{.spec.ports[0].nodePort}')
SERVICE_URL="http://localhost:$NODE_PORT"

echo -e "${YELLOW}Starting URL Shortener Stress Test Demo${NC}"
echo -e "Service URL: $SERVICE_URL"

# Show initial state
print_header "Initial State"
echo "Current pods:"
kubectl get pods -l app=url-shortener

echo -e "\nHPA Status:"
kubectl get hpa

# Run a single, intensive stress test
print_header "Running Stress Test"
echo "Sending 2000 requests with 200 concurrent connections..."
hey -n 2000 -c 200 $SERVICE_URL

# Show final state
print_header "Final State"
echo "Final pod count:"
kubectl get pods -l app=url-shortener

echo -e "\nHPA Status:"
kubectl get hpa

echo -e "\nResource Usage:"
kubectl top pods -l app=url-shortener

echo -e "\n${GREEN}Stress test completed!${NC}" 