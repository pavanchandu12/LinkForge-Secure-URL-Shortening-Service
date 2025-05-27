#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print section headers
print_header() {
    echo -e "\n${GREEN}=== $1 ===${NC}\n"
}

# Function to get pod status
get_pod_status() {
    print_header "Pod Status"
    kubectl get pods -o wide
}

# Function to get HPA status
get_hpa_status() {
    print_header "HPA Status"
    kubectl get hpa
}

# Function to get service status
get_service_status() {
    print_header "Service Status"
    kubectl get svc
}

# Function to get ingress status
get_ingress_status() {
    print_header "Ingress Status"
    kubectl get ingress
}

# Function to get pod logs
get_pod_logs() {
    print_header "Pod Logs"
    for pod in $(kubectl get pods -l app=url-shortener -o jsonpath='{.items[*].metadata.name}'); do
        echo -e "\n${YELLOW}Logs for pod: $pod${NC}"
        kubectl logs $pod --tail=50
    done
}

# Function to get resource usage
get_resource_usage() {
    print_header "Resource Usage"
    kubectl top pods
}

# Function to run stress test
run_stress_test() {
    print_header "Running Stress Test"
    
    # Get the service URL
    SERVICE_URL=$(minikube service url-shortener --url)
    echo -e "${YELLOW}Service URL: $SERVICE_URL${NC}"
    
    # Show initial state
    echo -e "\n${YELLOW}Initial State:${NC}"
    echo "Current pod count:"
    kubectl get pods -l app=url-shortener | wc -l
    
    echo -e "\nHPA status:"
    kubectl get hpa
    
    # Run multiple stress tests with increasing load
    echo -e "\n${YELLOW}Starting stress tests...${NC}"
    
    # Test 1: Light load
    echo -e "\n${GREEN}Test 1: Light Load (100 requests, 10 concurrent)${NC}"
    hey -n 100 -c 10 $SERVICE_URL
    
    # Wait for HPA to adjust
    echo -e "\n${YELLOW}Waiting for HPA to adjust...${NC}"
    sleep 10
    
    # Test 2: Medium load
    echo -e "\n${GREEN}Test 2: Medium Load (500 requests, 50 concurrent)${NC}"
    hey -n 500 -c 50 $SERVICE_URL
    
    # Wait for HPA to adjust
    echo -e "\n${YELLOW}Waiting for HPA to adjust...${NC}"
    sleep 10
    
    # Test 3: Heavy load
    echo -e "\n${GREEN}Test 3: Heavy Load (1000 requests, 100 concurrent)${NC}"
    hey -n 1000 -c 100 $SERVICE_URL
    
    # Wait for HPA to adjust
    echo -e "\n${YELLOW}Waiting for HPA to adjust...${NC}"
    sleep 10
    
    # Test 4: Very heavy load
    echo -e "\n${GREEN}Test 4: Very Heavy Load (2000 requests, 200 concurrent)${NC}"
    hey -n 2000 -c 200 $SERVICE_URL
    
    # Show final state
    echo -e "\n${YELLOW}Final State:${NC}"
    echo "Final pod count:"
    kubectl get pods -l app=url-shortener | wc -l
    
    echo -e "\nHPA status:"
    kubectl get hpa
    
    echo -e "\n${YELLOW}Resource Usage:${NC}"
    kubectl top pods -l app=url-shortener
    
    # Show pod logs
    echo -e "\n${YELLOW}Pod Logs:${NC}"
    for pod in $(kubectl get pods -l app=url-shortener -o jsonpath='{.items[*].metadata.name}'); do
        echo -e "\n${YELLOW}Logs for pod: $pod${NC}"
        kubectl logs $pod --tail=50
    done
}

# Main menu
while true; do
    echo -e "\n${GREEN}URL Shortener Monitoring Menu${NC}"
    echo "1. Show Pod Status"
    echo "2. Show HPA Status"
    echo "3. Show Service Status"
    echo "4. Show Ingress Status"
    echo "5. Show Pod Logs"
    echo "6. Show Resource Usage"
    echo "7. Run Stress Test"
    echo "8. Show All"
    echo "9. Exit"
    
    read -p "Select an option (1-9): " choice
    
    case $choice in
        1) get_pod_status ;;
        2) get_hpa_status ;;
        3) get_service_status ;;
        4) get_ingress_status ;;
        5) get_pod_logs ;;
        6) get_resource_usage ;;
        7) run_stress_test ;;
        8)
            get_pod_status
            get_hpa_status
            get_service_status
            get_ingress_status
            get_resource_usage
            ;;
        9) exit 0 ;;
        *) echo "Invalid option" ;;
    esac
    
    echo -e "\nPress Enter to continue..."
    read
done 