# Materi DevOps: Cloud Platforms, Monitoring, Security & GitOps

Dokumen ini mencakup 4 topik advanced DevOps dalam satu file untuk efisiensi pembelajaran.

---

# Part 1: Cloud Platforms (AWS Fundamentals)

## AWS Core Services

### EC2 (Compute)
```bash
# Launch instance via CLI
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type t2.micro \
  --key-name my-key \
  --security-group-ids sg-123456 \
  --subnet-id subnet-123456

# List instances
aws ec2 describe-instances

# Stop instance
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
```

### S3 (Storage)
```bash
# Create bucket
aws s3 mb s3://my-bucket

# Upload file
aws s3 cp file.txt s3://my-bucket/

# Sync directory
aws s3 sync ./local s3://my-bucket/

# Set bucket policy (public read)
aws s3api put-bucket-policy --bucket my-bucket --policy file://policy.json
```

### RDS (Database)
```bash
# Create MySQL instance
aws rds create-db-instance \
  --db-instance-identifier mydb \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password MyPassword123 \
  --allocated-storage 20
```

### VPC (Networking)
```bash
# Create VPC
aws ec2 create-vpc --cidr-block 10.0.0.0/16

# Create subnet
aws ec2 create-subnet \
  --vpc-id vpc-123456 \
  --cidr-block 10.0.1.0/24 \
  --availability-zone us-east-1a
```

---

# Part 2: Monitoring & Observability

## Prometheus + Grafana Stack

### Prometheus Setup

```yaml
# prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'node-exporter'
    static_configs:
      - targets: ['localhost:9100']
  
  - job_name: 'application'
    static_configs:
      - targets: ['app:8080']
```

### Docker Compose Monitoring Stack

```yaml
# docker-compose.yml
version: '3.9'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.retention.time=30d'
  
  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana
    depends_on:
      - prometheus
  
  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'

volumes:
  prometheus-data:
  grafana-data:
```

### Prometheus Queries (PromQL)

```promql
# CPU usage
100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# Memory usage
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100

# HTTP request rate
rate(http_requests_total[5m])

# 95th percentile response time
histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))
```

### Application Metrics (Python Example)

```python
from prometheus_client import Counter, Histogram, start_http_server
import time

# Metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total requests', ['method', 'endpoint'])
REQUEST_DURATION = Histogram('app_request_duration_seconds', 'Request duration')

@REQUEST_DURATION.time()
def process_request():
    REQUEST_COUNT.labels(method='GET', endpoint='/api').inc()
    time.sleep(0.1)

# Expose metrics
start_http_server(8000)
```

## ELK Stack (Logs)

### Docker Compose ELK

```yaml
version: '3.9'

services:
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.11.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    ports:
      - "9200:9200"
  
  logstash:
    image: docker.elastic.co/logstash/logstash:8.11.0
    volumes:
      - ./logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    depends_on:
      - elasticsearch
  
  kibana:
    image: docker.elastic.co/kibana/kibana:8.11.0
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
```

---

# Part 3: DevSecOps & Security

## Secret Management with Vault

### Run Vault

```bash
# Dev mode (not for production!)
docker run -d \
  --name vault \
  -p 8200:8200 \
  -e VAULT_DEV_ROOT_TOKEN_ID=myroot \
  vault:latest

# Set environment
export VAULT_ADDR='http://localhost:8200'
export VAULT_TOKEN='myroot'

# Store secret
vault kv put secret/db password=mypassword

# Read secret
vault kv get secret/db

# Delete secret
vault kv delete secret/db
```

### Use Vault in Application

```python
import hvac

client = hvac.Client(url='http://localhost:8200', token='myroot')

# Write secret
client.secrets.kv.v2.create_or_update_secret(
    path='myapp/db',
    secret=dict(password='supersecret')
)

# Read secret
secret = client.secrets.kv.v2.read_secret_version(path='myapp/db')
password = secret['data']['data']['password']
```

## Container Security Scanning

### Trivy (Vulnerability Scanner)

```bash
# Install
wget https://github.com/aquasecurity/trivy/releases/download/v0.48.0/trivy_0.48.0_Linux-64bit.tar.gz
tar zxvf trivy_0.48.0_Linux-64bit.tar.gz
sudo mv trivy /usr/local/bin/

# Scan image
trivy image nginx:latest

# Scan with severity
trivy image --severity HIGH,CRITICAL myapp:latest

# Scan filesystem
trivy fs /path/to/project

# In CI/CD
trivy image --exit-code 1 --severity CRITICAL myapp:latest
```

### Dockerfile Security Best Practices

```dockerfile
# ✅ Good Security Practices
FROM node:18-alpine  # Use specific, minimal base

# Don't run as root
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

WORKDIR /app

# Copy only necessary files
COPY package*.json ./
RUN npm ci --only=production

COPY --chown=nodejs:nodejs . .

# Switch to non-root user
USER nodejs

# No secrets in image
# Use build-time secrets for private packages
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc \
    npm install

EXPOSE 3000

CMD ["node", "server.js"]
```

## RBAC in Kubernetes

```yaml
# ServiceAccount
apiVersion: v1
kind: ServiceAccount
metadata:
  name: app-sa
  namespace: production

---
# Role
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: app-role
  namespace: production
rules:
- apiGroups: [""]
  resources: ["pods", "services"]
  verbs: ["get", "list", "watch"]

---
# RoleBinding
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: app-rolebinding
  namespace: production
subjects:
- kind: ServiceAccount
  name: app-sa
  namespace: production
roleRef:
  kind: Role
  name: app-role
  apiGroup: rbac.authorization.k8s.io
```

## Network Policies

```yaml
# Only allow specific traffic
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: api-network-policy
  namespace: production
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
```

---

# Part 4: GitOps with ArgoCD

## ArgoCD Concepts

**GitOps** = Git as single source of truth for infrastructure

```
Git Repo → ArgoCD → Kubernetes Cluster
(desired)   (sync)    (actual)
```

## Install ArgoCD

```bash
# Create namespace
kubectl create namespace argocd

# Install ArgoCD
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

## Create Application

### Git Repository Structure

```
app-repo/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
├── overlays/
│   ├── dev/
│   │   └── kustomization.yaml
│   ├── staging/
│   │   └── kustomization.yaml
│   └── prod/
│       └── kustomization.yaml
```

### ArgoCD Application

```yaml
# application.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: myapp
  namespace: argocd
spec:
  project: default
  
  source:
    repoURL: https://github.com/user/app-repo
    targetRevision: main
    path: overlays/prod
  
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
```

```bash
# Apply application
kubectl apply -f application.yaml

# Or via CLI
argocd app create myapp \
  --repo https://github.com/user/app-repo \
  --path overlays/prod \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production \
  --sync-policy automated
```

## Kustomize for Multi-Environment

### Base Configuration

```yaml
# base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: myapp:latest
        ports:
        - containerPort: 8080

# base/kustomization.yaml
resources:
  - deployment.yaml
  - service.yaml
```

### Environment Overlays

```yaml
# overlays/prod/kustomization.yaml
bases:
  - ../../base

replicas:
  - name: myapp
    count: 5

images:
  - name: myapp
    newTag: v1.0.0

namespace: production

configMapGenerator:
  - name: app-config
    literals:
      - ENV=production
      - LOG_LEVEL=warn
```

---

## 📝 Quick Reference Cards

### Monitoring Stack URLs
```
Prometheus: http://localhost:9090
Grafana:    http://localhost:3000 (admin/admin)
Kibana:     http://localhost:5601
ArgoCD:     http://localhost:8080
Vault:      http://localhost:8200
```

### Common Prometheus Queries
```promql
# CPU
rate(process_cpu_seconds_total[5m])

# Memory
process_resident_memory_bytes

# HTTP errors
rate(http_requests_total{status=~"5.."}[5m])

# Disk space
(node_filesystem_size_bytes - node_filesystem_free_bytes) / node_filesystem_size_bytes
```

### Security Checklist
- [ ] No secrets in code/images
- [ ] Use secret management (Vault)
- [ ] Scan containers (Trivy)
- [ ] RBAC enabled
- [ ] Network policies configured
- [ ] Non-root containers
- [ ] Image vulnerability scanning in CI

### GitOps Workflow
```
1. Update manifests in Git
2. Commit & push
3. ArgoCD detects change
4. ArgoCD syncs to cluster
5. Verify deployment
```

---

## 🎯 Learning Path

### Beginner
1. Setup Prometheus + Grafana
2. Create basic dashboards
3. Configure AWS resources
4. Run Vault in dev mode

### Intermediate
5. ELK stack for logs
6. Implement RBAC
7. Setup ArgoCD
8. Multi-environment with Kustomize

### Advanced
9. Custom Prometheus exporters
10. Advanced security scanning
11. Multi-cluster GitOps
12. Disaster recovery

---

**Advanced DevOps skills unlocked! 🚀🔒📊**
