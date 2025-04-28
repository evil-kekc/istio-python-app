# Python Flask App with Istio Integration

This project is a simple Flask web application deployed in Kubernetes using Istio for traffic management and monitoring.

## Project Structure

---

```text
├── Makefile
├── README.md
├── kustomization.yaml
├── patches
│   ├── grafana-cm.yaml
│   └── kustomization.yaml
├── python-app
│   ├── Dockerfile
│   ├── app.py
│   ├── k8s
│   │   ├── base
│   │   │   ├── app-service.yaml
│   │   │   ├── ingressgateway-istio.yaml
│   │   │   ├── kustomization.yaml
│   │   │   ├── v1
│   │   │   │   └── app-deployment-v1.yaml
│   │   │   ├── v2
│   │   │   │   └── app-deployment-v2.yaml
│   │   │   └── v3
│   │   │       └── app-deployment-v3.yaml
│   │   ├── destination-rule.yaml
│   │   ├── kustomization.yaml
│   │   ├── security
│   │   │   ├── auth-policy.yaml
│   │   │   ├── kustomization.yaml
│   │   │   └── peer-authentication.yaml
│   │   └── vs.yaml
│   └── templates
│       └── index.html
└── tests
    └── h2load.sh
```

- `app.py` - Main Flask application file.
- `Dockerfile` - Docker image for the application.
- `templates/index.html` - HTML template for the homepage.
- `Makefile` - Automation scripts for tasks like starting Minikube, installing Istio, and deploying the app.
- `k8s/` - Kubernetes manifests for deploying the application.
- `tests/h2load.sh` - Script for performance testing.
- `patches` - Patch `ConfigMap` to access grafana dashboard using istio `VirtualService`.

## Requirements

---

- [Python 3.11](https://www.python.org/downloads/release/python-3110/)
- [Docker](https://www.docker.com/)
- [Minikube](https://minikube.sigs.k8s.io/docs/)
- [Istio](https://istio.io/)
- [Kubernetes CLI](https://kubernetes.io/docs/reference/kubectl/) (`kubectl`)
- [Istio CLI](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/) (`istioctl`)

## Installation and Usage

---

### 1. Start Minikube
```bash
make start-minikube
```

### 2. Install Istio
```bash
make install-istio
```

### 3. Build Docker Image (optional)

You can build the Docker image for the application using the provided Dockerfile. The Dockerfile is located in the `python-app` directory.
```bash
docker build -t istio-python-app:latest python-app/
docker tag istio-python-app:latest <your-registry>/istio-python-app:latest
docker push <your-registry>/istio-python-app:latest
```

And then change the image name in the [deployments](./python-app/k8s/base) files located in `python-app/k8s/base/` (`v1`, `v2`, `v3` folders) to match your registry.

### 4. Deploy the Application to Kubernetes
```bash
make create-python-app
```
    
### 5. Forward istio-ingressgateway port
```bash
kubectl port-forward -n istio-system service/istio-ingressgateway 8080:80
```


## Accessing the Application

---

After deployment, the application will be accessible via the Istio Ingress Gateway. To get access by URL add the following into the `/etc/hosts` file:

```text
127.0.0.1       example.local
```

Then, you can access the application using the following URL:

```text
http://example.local:8080/app
```

To access the grafana dashboard you can use the following URL:

```text
http://example.local:8080/grafana
```

To access the Kiali dashboard, you can use the following URL:

```text
http://example.local:8080/kiali
```

You can also access to the API endpoint using the following command:

```bash
curl -H "Authorization: Bearer my-static-token-123" http://example.local:8080/app/api
```

## Testing the application

---

To test the application, you can use the `h2load.sh` script located in the `tests` directory. This script uses `h2load` to perform load testing on the application.
Use the following command to run the test:

```bash
make test-python-app
```

## Monitoring

---

- **[Prometheus](https://istio.io/latest/docs/ops/integrations/prometheus/)**: Application metrics.
- **[Kiali](https://istio.io/latest/docs/ops/integrations/kiali/)**: Visualization of network traffic.
