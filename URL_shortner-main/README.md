# URL Shortener Service

A modern, user-friendly URL shortener service built with FastAPI, Redis, and Docker. Features a beautiful, responsive web interface for easy URL shortening.

## Features

- Create short URLs from long URLs
- Redirect from short URLs to original URLs
- Persistent storage using Redis
- Containerized with Docker
- Modern, responsive web interface
- Copy-to-clipboard functionality
- Error handling and validation
- Mobile-friendly design
- Kubernetes deployment support
- High availability with multiple replicas
- Load balancing
- Persistent storage for Redis
- Automatic scaling with HPA
- Comprehensive monitoring and stress testing

## Prerequisites

- Docker
- Docker Compose
- Kubernetes cluster (for Kubernetes deployment)
- kubectl (for Kubernetes deployment)
- Minikube (for local Kubernetes development)
- hey (for stress testing)

## Setting up Local Kubernetes Development Environment

1. Install Minikube:
   ```bash
   # macOS (using Homebrew)
   brew install minikube
   
   # Linux
   curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
   sudo install minikube-linux-amd64 /usr/local/bin/minikube
   ```

2. Install kubectl:
   ```bash
   # macOS (using Homebrew)
   brew install kubectl
   
   # Linux
   curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
   sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
   ```

3. Install hey (for stress testing):
   ```bash
   # macOS (using Homebrew)
   brew install hey
   ```

4. Start Minikube:
   ```bash
   minikube start
   ```

5. Enable Minikube's Docker daemon:
   ```bash
   eval $(minikube docker-env)
   ```

## Running the Application

### Using Docker Compose (Development)

1. Clone the repository:
```bash
git clone <repository-url>
cd url-short
```

2. Build and start the containers:
```bash
docker-compose up --build
```

3. The application will be available at `http://localhost:8000`

### Using Kubernetes (Production)

1. Clone the repository:
```bash
git clone <repository-url>
cd url-short
```

2. Make sure Minikube is running:
```bash
minikube status
```

3. Deploy to Kubernetes:
```bash
cd k8s
./deploy.sh
```

4. The application will be available at `http://localhost:<NODE_PORT>`

If you're using Minikube, you might need to use the Minikube IP:
```bash
minikube service url-shortener --url
```

## Monitoring and Stress Testing

The application includes comprehensive monitoring and stress testing capabilities:

### Monitoring Script

Run the monitoring script to view various aspects of the application:
```bash
cd k8s
./monitor.sh
```

The monitoring script provides options to:
- Show pod status
- View HPA status
- Check service status
- Monitor ingress status
- View pod logs
- Check resource usage
- Run stress tests

### Stress Testing

The application includes built-in stress testing capabilities:

1. Using the monitoring script:
```bash
cd k8s
./monitor.sh
# Select option 7 to run stress test
```

2. Using the dedicated stress test script:
```bash
cd k8s
./stress-test.sh
```

The stress test will:
- Send 1000 total requests
- Use 100 concurrent connections
- Monitor HPA scaling
- Show response times and success rates
- Display resource usage

### Scaling Features

The application automatically scales based on load:
- Minimum 2 replicas
- Maximum 10 replicas
- Scales up when CPU utilization exceeds 70%
- Load balancing across all replicas

## Using the Web Interface

1. Open your browser and navigate to the application URL
2. Enter a long URL in the input field
3. Click "Shorten" or press Enter
4. Your shortened URL will appear below
5. Click "Copy" to copy the shortened URL to your clipboard

### Features of the Web Interface

- **Input Validation**: Automatically adds 'https://' if no protocol is specified
- **Copy to Clipboard**: One-click copying of shortened URLs
- **Error Handling**: Clear error messages for invalid inputs or server issues
- **Responsive Design**: Works perfectly on both desktop and mobile devices
- **Keyboard Support**: Press Enter to shorten URLs
- **Visual Feedback**: Success/error states and copy confirmation

## API Endpoints

The service also provides a REST API for programmatic access:

- `GET /`: Serve the web interface
- `POST /shorten`: Create a short URL
  ```bash
  curl -X POST "http://localhost:8000/shorten" \
       -H "Content-Type: application/json" \
       -d '{"long_url": "https://example.com"}'
  ```
  Response: `{"short_url": "/abc123"}`
- `GET /{short_code}`: Redirect to the original URL
  ```bash
  curl -L "http://localhost:8000/abc123"
  ```

## Development

The application is built with:
- FastAPI (Python web framework)
- Redis (In-memory data store)
- Docker (Containerization)
- Docker Compose (Service orchestration)
- HTML5/CSS3 (Modern web interface)
- JavaScript (Frontend functionality)
- Kubernetes (Container orchestration)
- HPA (Horizontal Pod Autoscaling)
- Ingress (Load balancing)

### Project Structure

```
url-short/
├── app.py              # FastAPI application
├── static/             # Frontend files
│   ├── index.html     # Main HTML file
│   ├── styles.css     # CSS styles
│   └── script.js      # Frontend JavaScript
├── requirements.txt    # Python dependencies
├── Dockerfile         # Application container
├── docker-compose.yml # Service orchestration
└── k8s/              # Kubernetes manifests
    ├── redis-configmap.yaml
    ├── redis-deployment.yaml
    ├── url-shortener-deployment.yaml
    ├── hpa.yaml
    ├── ingress.yaml
    ├── deploy.sh
    ├── monitor.sh
    └── stress-test.sh
```

## Kubernetes Deployment Details

The Kubernetes deployment includes:

### URL Shortener Deployment
- 3 replicas for high availability
- Resource limits and requests
- Health checks and readiness probes
- NodePort service for external access
- HPA for automatic scaling
- Ingress for load balancing

### Redis Deployment
- Single replica (can be scaled if needed)
- Persistent storage using PVC
- ConfigMap for configuration
- ClusterIP service for internal access

### Configuration
- Redis configuration via ConfigMap
- Environment variables for service discovery
- Resource limits for both services
- HPA configuration for automatic scaling

## Troubleshooting

### Common Issues

1. **Minikube not running**
   ```bash
   minikube start
   ```

2. **Docker image not found**
   Make sure you're using Minikube's Docker daemon:
   ```bash
   eval $(minikube docker-env)
   ```

3. **Cannot access the application**
   Get the correct URL:
   ```bash
   minikube service url-shortener --url
   ```

4. **Kubernetes resources not created**
   Check Minikube status:
   ```bash
   minikube status
   kubectl get pods
   ```

5. **Stress test not working**
   Make sure hey is installed:
   ```bash
   brew install hey
   ```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request
