#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Build the Docker image
echo "Building Docker image..."
cd "$PROJECT_ROOT"
docker build -t url-shortener:latest .

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
cd "$SCRIPT_DIR"
kubectl apply -f redis-configmap.yaml
kubectl apply -f redis-deployment.yaml
kubectl apply -f url-shortener-deployment.yaml
kubectl apply -f hpa.yaml
kubectl apply -f ingress.yaml

# Enable metrics-server for HPA
echo "Enabling metrics-server..."
minikube addons enable metrics-server

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/redis
kubectl wait --for=condition=available --timeout=300s deployment/url-shortener

# Wait for metrics-server to be ready
echo "Waiting for metrics-server to be ready..."
sleep 30

# Get the service URL
echo "Getting service URL..."
SERVICE_URL=$(minikube service url-shortener --url)
echo "Application is deployed! Access it at: $SERVICE_URL"

# Add host entry for ingress
echo "Adding host entry for ingress..."
echo "$(minikube ip) url-shortener.local" | sudo tee -a /etc/hosts

echo -e "\nDeployment complete! You can now:"
echo "1. Access the application at: $SERVICE_URL"
echo "2. Use the monitoring script: ./monitor.sh"
echo "3. Access via ingress at: http://url-shortener.local" 