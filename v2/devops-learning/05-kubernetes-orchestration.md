# Materi Pembelajaran: Kubernetes Container Orchestration

> **Workflow**: `/05-kubernetes-basics`  
> **Durasi**: 6-8 jam  
> **Level**: Intermediate to Advanced  
> **Prerequisites**: Docker, Linux, YAML basics

---

## 📚 Daftar Isi

1. [Pengenalan Kubernetes](#pengenalan-kubernetes)
2. [Kubernetes Architecture](#kubernetes-architecture)
3. [Pods](#pods)
4. [Deployments](#deployments)
5. [Services](#services)
6. [ConfigMaps & Secrets](#configmaps-secrets)
7. [Persistent Volumes](#persistent-volumes)
8. [Advanced Concepts](#advanced-concepts)
9. [Hands-On Exercises](#exercises)
10. [Troubleshooting](#troubleshooting)

---

## 1. Pengenalan Kubernetes

### Apa itu Kubernetes?

**Kubernetes (K8s)** = Container orchestration platform

**Solves**:
- Deploy containers at scale
- Auto-scaling
- Load balancing
- Self-healing
- Rolling updates
- Service discovery

### Why Kubernetes?

**Without K8s**:
```
Docker run image1
Docker run image2
Docker run image3
# What if container crashes?
# How to scale?
# How to load balance?
```

**With K8s**:
```yaml
# Declare desired state
replicas: 3
# K8s ensures it's maintained
```

### Kubernetes vs Docker

| Aspek | Docker | Kubernetes |
|-------|--------|------------|
| **Purpose** | Containerization | Orchestration |
| **Scope** | Single host | Multi-host cluster |
| **Scale** | Small | Production-scale |
| **Feature** | Run containers | Manage, scale, heal |

**They work together**: Docker creates containers, K8s orchestrates them

---

## 2. Kubernetes Architecture

### Cluster Components

```
┌─────────────── Control Plane ───────────────┐
│                                              │
│  ┌──────────┐  ┌──────────┐  ┌───────────┐ │
│  │API Server│  │Scheduler │  │Controller │ │
│  └──────────┘  └──────────┘  └───────────┘ │
│  ┌──────────┐                               │
│  │  etcd    │  (cluster state storage)      │
│  └──────────┘                               │
└──────────────────────────────────────────────┘
               │
        ┌──────┴──────┐
        │             │
┌───────▼──────┐  ┌──▼────────────┐
│ Worker Node  │  │ Worker Node   │
│              │  │               │
│ ┌──────────┐ │  │ ┌──────────┐  │
│ │ kubelet  │ │  │ │ kubelet  │  │
│ ├──────────┤ │  │ ├──────────┤  │
│ │ Pod      │ │  │ │ Pod      │  │
│ │ Pod      │ │  │ │ Pod      │  │
│ └──────────┘ │  │ └──────────┘  │
└──────────────┘  └───────────────┘
```

**Master Node** (Control Plane):
- **API Server**: Entry point, REST API
- **Scheduler**: Assign pods to nodes
- **Controller Manager**: Maintain desired state
- **etcd**: Key-value store (cluster data)

**Worker Node**:
- **kubelet**: Agent on each node
- **kube-proxy**: Network proxy
- **Container Runtime**: Docker/containerd

### kubectl

**kubectl** = Command-line tool to interact with K8s

```bash
# General syntax
kubectl [command] [type] [name] [flags]

# Examples
kubectl get pods
kubectl describe pod my-pod
kubectl delete deployment my-app
```

---

## 3. Pods

### Apa itu Pod?

**Pod** = Smallest deployable unit in K8s
- Contains 1+ containers
- Shares network namespace
- Shares storage volumes
- Has unique IP address

```
┌─────── Pod ───────┐
│                   │
│ ┌───────────────┐ │
│ │ Container 1   │ │
│ └───────────────┘ │
│ ┌───────────────┐ │
│ │ Container 2   │ │
│ └───────────────┘ │
│                   │
│ IP: 10.1.1.5      │
└───────────────────┘
```

### Create Pod

```yaml
# pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:1.25-alpine
    ports:
    - containerPort: 80
```

```bash
# Apply
kubectl apply -f pod.yaml

# Verify
kubectl get pods
kubectl describe pod nginx-pod

# Logs
kubectl logs nginx-pod

# Execute command
kubectl exec nginx-pod -- ls /usr/share/nginx/html

# Interactive shell
kubectl exec -it nginx-pod -- sh

# Delete
kubectl delete pod nginx-pod
```

### Multi-Container Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-with-sidecar
spec:
  containers:
  - name: app
    image: myapp:latest
    ports:
    - containerPort: 8080
  
  - name: log-collector
    image: fluent/fluentd:latest
    volumeMounts:
    - name: logs
      mountPath: /var/log
  
  volumes:
  - name: logs
    emptyDir: {}
```

---

## 4. Deployments

### Why Deployments?

**Pods alone**:
- Manual scaling
- No self-healing
- Manual updates

**Deployments**:
- Declarative updates
- Auto-scaling
- Rolling updates/rollbacks
- Self-healing

### Create Deployment

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  template:
    metadata:
      labels:
        app: web
    spec:
      containers:
      - name: web
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
```

```bash
# Create deployment
kubectl apply -f deployment.yaml

# Get deployments
kubectl get deployments

# Get pods (created by deployment)
kubectl get pods -l app=web

# Describe deployment
kubectl describe deployment web-app

# Scale deployment
kubectl scale deployment web-app --replicas=5

# Update image
kubectl set image deployment/web-app web=nginx:1.26-alpine

# Rollout status
kubectl rollout status deployment/web-app

# Rollout history
kubectl rollout history deployment/web-app

# Rollback
kubectl rollout undo deployment/web-app

# Delete deployment
kubectl delete deployment web-app
```

### Rolling Update Strategy

```yaml
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        # Max pods above desired
      maxUnavailable: 1  # Max pods unavailable
```

**Process**:
```
Initial:  [v1] [v1] [v1]
Step 1:   [v1] [v1] [v1] [v2]  ← Create new
Step 2:   [v1] [v1] [v2]       ← Remove old
Step 3:   [v1] [v1] [v2] [v2]
Step 4:   [v1] [v2] [v2]
Step 5:   [v2] [v2] [v2]       ← Complete
```

---

## 5. Services

### Why Services?

**Problem**:
- Pod IPs change when recreated
- Need stable endpoint
- Need load balancing

**Service** = Stable IP & DNS for pods

### Service Types

| Type | Purpose | Use Case |
|------|---------|----------|
| ClusterIP | Internal only | Database, API |
| NodePort | External via node port | Development |
| LoadBalancer | Cloud load balancer | Production |
| ExternalName | DNS alias | External service |

### ClusterIP Service

```yaml
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: ClusterIP
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

```bash
# Create service
kubectl apply -f service.yaml

# Get services
kubectl get services

# Test from inside cluster
kubectl run test-pod --image=alpine --rm -it -- sh
wget -O- http://web-service
```

### NodePort Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-nodeport
spec:
  type: NodePort
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
    nodePort: 30080  # 30000-32767
```

Access: `http://<node-ip>:30080`

### LoadBalancer Service

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-lb
spec:
  type: LoadBalancer
  selector:
    app: web
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
```

**On cloud providers**: Creates actual load balancer  
**On Minikube**: Use `minikube service web-lb`

---

## 6. ConfigMaps & Secrets

### ConfigMap

**ConfigMap** = Store configuration data (non-sensitive)

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  APP_NAME: "My Application"
  APP_ENV: "production"
  LOG_LEVEL: "info"
  database.conf: |
    host=postgres
    port=5432
    name=mydb
```

```bash
# Create
kubectl apply -f configmap.yaml

# Create from literal
kubectl create configmap app-config \
  --from-literal=APP_NAME="My App" \
  --from-literal=ENV=prod

# Create from file
kubectl create configmap nginx-config \
  --from-file=nginx.conf

# Get
kubectl get configmaps
kubectl describe configmap app-config
```

### Use ConfigMap in Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:latest
    # Use all keys as env vars
    envFrom:
    - configMapRef:
        name: app-config
    
    # Or specific keys
    env:
    - name: APP_NAME
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_NAME
    
    # Or as volume
    volumeMounts:
    - name: config
      mountPath: /etc/config
  
  volumes:
  - name: config
    configMap:
      name: app-config
```

### Secrets

**Secret** = Store sensitive data (base64 encoded)

```yaml
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secret
type: Opaque
data:
  # base64 encoded values
  DB_PASSWORD: bXlzZWNyZXRwYXNzd29yZA==
  API_KEY: YWJjZGVmZ2hpamtsbW5vcA==
```

```bash
# Encode to base64
echo -n "mypassword" | base64
# bXlwYXNzd29yZA==

# Create secret from literal
kubectl create secret generic app-secret \
  --from-literal=DB_PASSWORD=mypassword \
  --from-literal=API_KEY=abc123

# Create from file
kubectl create secret generic ssh-key \
  --from-file=ssh-privatekey=~/.ssh/id_rsa

# Get secrets
kubectl get secrets

# View secret
kubectl get secret app-secret -o yaml
```

### Use Secret in Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app-pod
spec:
  containers:
  - name: app
    image: myapp:latest
    env:
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: app-secret
          key: DB_PASSWORD
    
    # As volume
    volumeMounts:
    - name: secrets
      mountPath: /etc/secrets
      readOnly: true
  
  volumes:
  - name: secrets
    secret:
      secretName: app-secret
```

---

## 7. Persistent Volumes

### Storage Architecture

```
PersistentVolumeClaim (PVC)
        ↓ binds to
PersistentVolume (PV)
        ↓ backed by
Storage (NFS, Cloud disk, etc.)
```

### PersistentVolume

```yaml
# pv.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: my-pv
spec:
  capacity:
    storage: 5Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/myapp
```

### PersistentVolumeClaim

```yaml
# pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
```

### Use PVC in Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: db-pod
spec:
  containers:
  - name: postgres
    image: postgres:15-alpine
    volumeMounts:
    - name: postgres-storage
      mountPath: /var/lib/postgresql/data
  
  volumes:
  - name: postgres-storage
    persistentVolumeClaim:
      claimName: my-pvc
```

---

## 8. Advanced Concepts

### Namespaces

**Namespace** = Virtual cluster for isolation

```bash
# List namespaces
kubectl get namespaces

# Create namespace
kubectl create namespace dev
kubectl create namespace staging
kubectl create namespace production

# Deploy to namespace
kubectl apply -f deployment.yaml -n dev

# Set default namespace
kubectl config set-context --current --namespace=dev

# Get resources from all namespaces
kubectl get pods --all-namespaces
```

### Ingress

**Ingress** = HTTP(S) routing to services

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 5000
```

### HorizontalPodAutoscaler

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web-app
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### ResourceQuota

```yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: dev-quota
  namespace: dev
spec:
  hard:
    requests.cpu: "4"
    requests.memory: 8Gi
    limits.cpu: "8"
    limits.memory: 16Gi
    persistentvolumeclaims: "5"
    pods: "10"
```

---

## 9. Hands-On Exercises

### Exercise 1: Deploy Application

```bash
# 1. Create deployment
cat > nginx-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
EOF

kubectl apply -f nginx-deployment.yaml

# 2. Expose with service
kubectl expose deployment nginx --port=80 --type=NodePort

# 3. Verify
kubectl get deployments
kubectl get pods
kubectl get services

# 4. Scale
kubectl scale deployment nginx --replicas=5

# 5. Cleanup
kubectl delete deployment nginx
kubectl delete service nginx
```

---

### Exercise 2: Full Stack App

```bash
# 1. Create namespace
kubectl create namespace fullstack

# 2. Database secret
kubectl create secret generic db-secret \
  --from-literal=POSTGRES_PASSWORD=mysecret \
  -n fullstack

# 3. Database deployment
cat > db-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres
  namespace: fullstack
spec:
  replicas: 1
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        env:
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: POSTGRES_PASSWORD
        ports:
        - containerPort: 5432
---
apiVersion: v1
kind: Service
metadata:
  name: postgres
  namespace: fullstack
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
EOF

kubectl apply -f db-deployment.yaml

# 4. API deployment
cat > api-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: fullstack
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: myapi:latest
        env:
        - name: DATABASE_URL
          value: postgresql://postgres:5432/myapp
        ports:
        - containerPort: 5000
---
apiVersion: v1
kind: Service
metadata:
  name: api
  namespace: fullstack
spec:
  selector:
    app: api
  ports:
  - port: 5000
EOF

kubectl apply -f api-deployment.yaml

# 5. Verify
kubectl get all -n fullstack
```

---

## 10. Troubleshooting

### Pod Not Running

```bash
# Check pod status
kubectl get pods

# Describe pod
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>

# Previous container logs
kubectl logs <pod-name> --previous

# Events
kubectl get events --sort-by='.lastTimestamp'
```

### Common Issues

**ImagePullBackOff**:
```bash
# Check image name
kubectl describe pod <pod-name>
# Fix: Correct image name/tag
```

**CrashLoopBackOff**:
```bash
# Check logs
kubectl logs <pod-name>
# Fix: Fix application error
```

**Pending**:
```bash
# Check events
kubectl describe pod <pod-name>
# Common: Insufficient resources
```

---

## 📝 kubectl Cheat Sheet

```bash
# Get resources
kubectl get pods
kubectl get deployments
kubectl get services
kubectl get all

# Describe
kubectl describe pod <name>
kubectl describe deployment <name>

# Logs
kubectl logs <pod-name>
kubectl logs -f <pod-name>

# Execute
kubectl exec -it <pod-name> -- bash

# Apply/Delete
kubectl apply -f file.yaml
kubectl delete -f file.yaml

# Scale
kubectl scale deployment <name> --replicas=5

# Rollout
kubectl rollout status deployment/<name>
kubectl rollout undo deployment/<name>

# Port forward
kubectl port-forward pod/<name> 8080:80
```

---

## 🎯 Next Steps

1. **Practice**: Deploy real applications
2. **Learn Helm**: Package manager for K8s
3. **Study**: RBAC, Network Policies
4. **Explore**: Service Mesh (Istio)
5. **Certify**: CKA/CKAD

---

## 📚 Resources

- [Kubernetes Docs](https://kubernetes.io/docs/)
- [KillerCoda K8s](https://killercoda.com/kubernetes)
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)

---

**Selamat! Anda sudah menguasai Kubernetes basics! ☸️**

Keep learning and practicing! 🚀
