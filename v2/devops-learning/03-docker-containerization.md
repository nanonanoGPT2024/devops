# Materi Pembelajaran: Docker Containerization Fundamentals

> **Workflow**: `/03-docker-basics`  
> **Durasi**: 4-5 jam  
> **Level**: Beginner to Intermediate  
> **Prerequisites**: Linux environment & Git basics

---

## 📚 Daftar Isi

1. [Pengenalan Containerization](#pengenalan-containerization)
2. [Docker Architecture](#docker-architecture)
3. [Docker Images](#docker-images)
4. [Docker Containers](#docker-containers)
5. [Dockerfile Best Practices](#dockerfile-best-practices)
6. [Docker Networking](#docker-networking)
7. [Docker Volumes](#docker-volumes)
8. [Docker Compose](#docker-compose)
9. [Hands-On Exercises](#exercises)
10. [Troubleshooting](#troubleshooting)

---

## 1. Pengenalan Containerization

### Masalah Tradisional Deployment

**"It works on my machine!"** 🤷‍♂️

**Problems**:
- Different OS/libraries di development vs production
- Dependency conflicts
- Slow deployment process
- Resource waste dengan VMs

### Apa itu Container?

**Container** adalah unit software yang package code dan semua dependencies-nya.

 **Benefits**:
- Portable (run anywhere)
- Lightweight (share OS kernel)
- Fast startup (seconds)
- Consistent environment
- Resource efficient

### Container vs Virtual Machine

| Aspek | Container | Virtual Machine |
|-------|-----------|-----------------|
| **OS** | Share host kernel | Full OS per VM |
| **Size** | MBs | GBs |
| **Startup** | Seconds | Minutes |
| **Resources** | Lightweight | Heavy |
| **Isolation** | Process-level | Hardware-level |

```
Virtual Machines:
┌──────────────────────┐
│ App A │ App B │ App C│
│ Bins  │ Bins  │ Bins │
│ OS    │ OS    │ OS   │
├──────────────────────┤
│    Hypervisor        │
├──────────────────────┤
│  Host OS             │
└──────────────────────┘

Containers:
┌──────────────────────┐
│ App A │ App B │ App C│
│ Bins  │ Bins  │ Bins │
├──────────────────────┤
│    Docker Engine     │
├──────────────────────┤
│  Host OS             │
└──────────────────────┘
```

---

## 2. Docker Architecture

### Docker Components

```
┌─────────────┐
│ Docker CLI  │ ← User interface
└──────┬──────┘
       │
┌──────▼──────┐
│Docker Daemon│ ← Docker engine
└──────┬──────┘
       │
   ┌───┴───┐
   │       │
┌──▼───┐ ┌─▼──────┐
│Images│ │Container│
└──────┘ └────────┘
```

**Docker Client**: CLI untuk interact dengan Docker  
**Docker Daemon**: Background service (dockerd)  
**Docker Images**: Blueprint untuk containers  
**Docker Containers**: Running instances  
**Docker Registry**: Store images (Docker Hub)

### Docker Commands Flow

```bash
docker pull     # Download image from registry
docker build    # Build image from Dockerfile
docker run      # Create & start container from image
docker ps       # List running containers
docker stop     # Stop container
docker rm       # Remove container
```

---

## 3. Docker Images

### Apa itu Image?

**Docker Image** = Read-only template untuk create container

**Image layers**:
```
┌─────────────────────┐
│ App Layer          │ ← Your app
├─────────────────────┤
│ Dependencies Layer │ ← npm/pip packages
├─────────────────────┤
│ Runtime Layer      │ ← Node.js/Python
├─────────────────────┤
│ Base OS Layer      │ ← Ubuntu/Alpine
└─────────────────────┘
```

### Working with Images

#### Pull Images

```bash
# Pull from Docker Hub
docker pull nginx

# Pull specific version
docker pull nginx:1.25-alpine

# Pull from different registry
docker pull gcr.io/google-containers/nginx
```

#### List Images

```bash
# List all images
docker images

# Format output
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"
```

#### Remove Images

```bash
# Remove specific image
docker rmi nginx:latest

# Remove by ID
docker rmi abc123def456

# Remove unused images
docker image prune

# Remove all unused
docker image prune -a
```

#### Search Images

```bash
# Search Docker Hub
docker search python

# Filter by stars
docker search --filter stars=100 nginx
```

---

## 4. Docker Containers

### Container Lifecycle

```
docker create → created
docker start  → running
docker stop   → stopped
docker rm     → deleted
```

### Run Containers

#### Basic Run

```bash
# Run container (pull if not exists)
docker run nginx

# Run in detached mode (background)
docker run -d nginx

# Run with name
docker run -d --name my-nginx nginx

# Run interactively
docker run -it ubuntu bash
```

#### Port Mapping

```bash
# Map host:container port
docker run -d -p 8080:80 nginx

# Multiple ports
docker run -d -p 8080:80 -p 8443:443 nginx

# All exposed ports
docker run -d -P nginx
```

#### Environment Variables

```bash
# Single env var
docker run -e "ENV=production" myapp

# Multiple vars
docker run -e "DB_HOST=localhost" -e "DB_PORT=5432" myapp

# Env file
docker run --env-file .env myapp
```

### Manage Containers

#### List Containers

```bash
# Running containers
docker ps

# All containers (including stopped)
docker ps -a

# Latest created
docker ps -l

# Custom format
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
```

#### Start/Stop Containers

```bash
# Stop container
docker stop container_name

# Start stopped container
docker start container_name

# Restart container
docker restart container_name

# Pause/unpause
docker pause container_name
docker unpause container_name
```

#### Execute Commands

```bash
# Execute command in running container
docker exec container_name ls /app

# Interactive shell
docker exec -it container_name bash

# Run as specific user
docker exec -u root container_name whoami
```

#### View Logs

```bash
# View logs
docker logs container_name

# Follow logs (realtime)
docker logs -f container_name

# Last N lines
docker logs --tail 100 container_name

# With timestamps
docker logs -t container_name
```

#### Inspect Container

```bash
# Full details (JSON)
docker inspect container_name

# Specific field
docker inspect -f '{{.State.Status}}' container_name
docker inspect -f '{{.NetworkSettings.IPAddress}}' container_name
```

#### Remove Containers

```bash
# Remove stopped container
docker rm container_name

# Force remove running container
docker rm -f container_name

# Remove all stopped containers
docker container prune
```

---

## 5. Dockerfile Best Practices

### Dockerfile Structure

```dockerfile
# 1. Base image
FROM python:3.11-alpine

# 2. Metadata
LABEL maintainer="you@example.com"

# 3. Environment variables
ENV APP_HOME=/app \
    PYTHONUNBUFFERED=1

# 4. Working directory
WORKDIR $APP_HOME

# 5. Copy files
COPY requirements.txt .

# 6. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 7. Copy application
COPY . .

# 8. Expose port
EXPOSE 5000

# 9. User (security)
USER nobody

# 10. Command
CMD ["python", "app.py"]
```

### Best Practices

#### 1. Use Official Base Images

```dockerfile
# ✅ Good
FROM python:3.11-alpine

# ❌ Avoid
FROM random-user/python-custom
```

#### 2. Use Specific Tags

```dockerfile
# ✅ Good - reproducible
FROM nginx:1.25-alpine

# ❌ Bad - unpredictable
FROM nginx:latest
```

#### 3. Minimize Layers

```dockerfile
# ❌ Bad - multiple layers
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y vim

# ✅ Good - single layer
RUN apt-get update && \
    apt-get install -y \
    curl \
    vim && \
    rm -rf /var/lib/apt/lists/*
```

#### 4. Multi-Stage Builds

```dockerfile
# Stage 1: Build
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
USER node
CMD ["node", "dist/server.js"]
```

**Benefits**:
- Smaller final image
- No build tools in production
- Security improvement

#### 5. Use .dockerignore

```bash
# .dockerignore
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.vscode
*.log
```

#### 6. Don't Run as Root

```dockerfile
# ✅ Good - run as non-root
FROM node:18-alpine
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001
USER nodejs
CMD ["node", "app.js"]

# ❌ Bad - runs as root
FROM node:18-alpine
CMD ["node", "app.js"]
```

### Complete Example: Python Flask App

```dockerfile
# Multi-stage build for Python Flask
FROM python:3.11-alpine AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache gcc musl-dev

# Copy requirements
COPY requirements.txt .

# Install Python packages
RUN pip wheel --no-cache-dir --no-deps --wheel-dir /app/wheels -r requirements.txt

# Production stage
FROM python:3.11-alpine

WORKDIR /app

# Install runtime dependencies only
RUN apk add --no-cache libpq

# Copy wheels from builder
COPY --from=builder /app/wheels /wheels
COPY --from=builder /app/requirements.txt .

# Install packages from wheels
RUN pip install --no-cache /wheels/*

# Copy application
COPY . .

# Create non-root user
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=3s \
  CMD python -c "import requests; requests.get('http://localhost:5000/health')"

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
```

---

## 6. Docker Networking

### Network Drivers

| Driver | Use Case |
|--------|----------|
| bridge | Default, containers on same host |
| host | Container uses host network |
| none | No networking |
| overlay | Multi-host (Swarm/K8s) |

### Network Commands

```bash
# List networks
docker network ls

# Create network
docker network create my-network

# Inspect network
docker network inspect my-network

# Connect container to network
docker network connect my-network container_name

# Disconnect
docker network disconnect my-network container_name

# Remove network
docker network rm my-network
```

### Container Communication

#### Same Network

```bash
# Create network
docker network create app-network

# Run database
docker run -d --name postgres \
  --network app-network \
  -e POSTGRES_PASSWORD=secret \
  postgres:15-alpine

# Run app (can connect via hostname "postgres")
docker run -d --name web \
  --network app-network \
  -e DB_HOST=postgres \
  myapp:latest
```

**Containers can communicate using container names as DNS!**

---

## 7. Docker Volumes

### Why Volumes?

**Problem**: Container data is ephemeral (lost when container is removed)

**Solution**: Volumes for persistent data

### Volume Types

#### Named Volumes

```bash
# Create volume
docker volume create my-data

# Use volume
docker run -d -v my-data:/var/lib/mysql mysql:8

# List volumes
docker volume ls

# Inspect volume
docker volume inspect my-data

# Remove volume
docker volume rm my-data
```

#### Bind Mounts

```bash
# Mount host directory
docker run -d \
  -v /host/path:/container/path \
  nginx

# Current directory (development)
docker run -d \
  -v $(pwd):/app \
  node:18-alpine
```

#### tmpfs Mounts (Temporary)

```bash
# In-memory storage
docker run -d \
  --tmpfs /tmp \
  myapp
```

### Volume Example: PostgreSQL

```bash
# Create volume
docker volume create postgres-data

# Run PostgreSQL with persistent storage
docker run -d \
  --name my-postgres \
  -v postgres-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=mysecret \
  postgres:15-alpine

# Data persists even if container is removed!
docker rm -f my-postgres
docker run -d \
  --name my-postgres-2 \
  -v postgres-data:/var/lib/postgresql/data \
  -e POSTGRES_PASSWORD=mysecret \
  postgres:15-alpine
# Data still there!
```

---

## 8. Docker Compose

### Why Docker Compose?

**Problem**: Managing multiple containers with complex commands

**Solution**: Define multi-container apps in YAML

### docker-compose.yml Structure

```yaml
version: '3.9'

services:
  # Service definitions
  
volumes:
  # Volume definitions
  
networks:
  # Network definitions
```

### Basic Example

```yaml
version: '3.9'

services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html
    networks:
      - frontend

  api:
    build: ./api
    environment:
      - DATABASE_URL=postgresql://db:5432/myapp
    depends_on:
      - db
    networks:
      - frontend
      - backend

  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_PASSWORD=secret
    volumes:
      - db-data:/var/lib/postgresql/data
    networks:
      - backend

volumes:
  db-data:

networks:
  frontend:
  backend:
```

### Docker Compose Commands

```bash
# Start services
docker-compose up

# Detached mode
docker-compose up -d

# Build and start
docker-compose up --build

# Stop services
docker-compose stop

# Stop and remove
docker-compose down

# Remove with volumes
docker-compose down -v

# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# List running services
docker-compose ps

# Execute command
docker-compose exec web sh

# Run one-off command
docker-compose run api python manage.py migrate
```

### Complete Example: Full Stack App

```yaml
version: '3.9'

services:
  # Frontend
  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
    environment:
      - REACT_APP_API_URL=http://localhost:5000
    volumes:
      - ./frontend:/app
      - /app/node_modules
    networks:
      - app-network

  # Backend API
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    ports:
      - "5000:5000"
    environment:
      - DATABASE_URL=postgresql://postgres:secret@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis
    volumes:
      - ./backend:/app
    networks:
      - app-network

  # Database
  db:
    image: postgres:15-alpine
    environment:
      - POSTGRES_DB=myapp
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=secret
    volumes:
      - postgres-data:/var/lib/postgresql/data
    ports:
      - "5432:5432"
    networks:
      - app-network

  # Redis
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    networks:
      - app-network

volumes:
  postgres-data:

networks:
  app-network:
    driver: bridge
```

---

## 9. Hands-On Exercises

### Exercise 1: Run Your First Container

```bash
# 1. Pull and run Nginx
docker run -d --name my-first-nginx -p 8080:80 nginx:alpine

# 2. Verify
docker ps
curl http://localhost:8080

# 3. View logs
docker logs my-first-nginx

# 4. Execute command
docker exec my-first-nginx ls /usr/share/nginx/html

# 5. Stop and remove
docker stop my-first-nginx
docker rm my-first-nginx
```

**Verification**:
- [ ] Container running
- [ ] Accessed via browser
- [ ] Logs visible

---

### Exercise 2: Build Custom Image

```bash
# 1. Create project
mkdir docker-app
cd docker-app

# 2. Create app
cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 3. Requirements
echo "flask==3.0.0" > requirements.txt

# 4. Dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.11-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 5000
CMD ["python", "app.py"]
EOF

# 5. Build
docker build -t my-flask-app:v1 .

# 6. Run
docker run -d -p 5000:5000 --name flask-app my-flask-app:v1

# 7. Test
curl http://localhost:5000

# 8. Cleanup
docker stop flask-app
docker rm flask-app
```

**Verification**:
- [ ] Image built successfully
- [ ] App responds on port 5000

---

### Exercise 3: Multi-Container with Docker Compose

```bash
# 1. Create project structure
mkdir fullstack-app
cd fullstack-app
mkdir backend frontend

# 2. Backend (backend/app.py)
cat > backend/app.py << 'EOF'
from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/api/health')
def health():
    return jsonify(status='ok', message='Backend is running')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 3. Backend Dockerfile
cat > backend/Dockerfile << 'EOF'
FROM python:3.11-alpine
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
CMD ["python", "app.py"]
EOF

echo "flask==3.0.0" > backend/requirements.txt

# 4. Frontend (frontend/index.html)
cat > frontend/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>Fullstack App</title></head>
<body>
    <h1>Fullstack Docker App</h1>
    <button onclick="checkAPI()">Check API</button>
    <div id="result"></div>
    <script>
    async function checkAPI() {
        const res = await fetch('http://localhost:5000/api/health');
        const data = await res.json();
        document.getElementById('result').innerText = JSON.stringify(data);
    }
    </script>
</body>
</html>
EOF

# 5. Frontend Dockerfile
cat > frontend/Dockerfile << 'EOF'
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/
EOF

# 6. docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.9'

services:
  frontend:
    build: ./frontend
    ports:
      - "80:80"
    depends_on:
      - backend

  backend:
    build: ./backend
    ports:
      - "5000:5000"
EOF

# 7. Start
docker-compose up -d

# 8. Test
curl http://localhost:5000/api/health
# Open browser: http://localhost

# 9. View logs
docker-compose logs -f

# 10. Cleanup
docker-compose down
```

**Verification**:
- [ ] Both services running
- [ ] Frontend accessible
- [ ] Backend API responds

---

## 10. Troubleshooting

### Issue 1: Port Already in Use

**Error**: "Bind for 0.0.0.0:8080 failed"

**Solution**:
```bash
# Find process
sudo lsof -i :8080

# Kill process or use different port
docker run -p 8081:80 nginx
```

---

### Issue 2: Permission Denied

**Error**: "permission denied while trying to connect"

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

---

### Issue 3: Image Not Found

**Error**: "Unable to find image 'xxx' locally"

**Solution**:
```bash
# Pull explicitly
docker pull image:tag

# Check spelling
docker search image_name
```

---

### Issue 4: Container Exits Immediately

**Check logs**:
```bash
docker logs container_name
docker logs --tail 50 container_name
```

**Common causes**:
- Application error
- Missing environment variables
- Wrong CMD/ENTRYPOINT

---

## 📝 Docker Cheat Sheet

### Images
```bash
docker pull image:tag       # Download image
docker build -t name:tag .  # Build image
docker images              # List images
docker rmi image:tag       # Remove image
```

### Containers
```bash
docker run -d -p 8080:80 nginx     # Run container
docker ps                          # List running
docker ps -a                       # List all
docker stop container              # Stop
docker start container             # Start
docker rm container                # Remove
docker logs -f container           # View logs
docker exec -it container bash     # Shell access
```

### Docker Compose
```bash
docker-compose up -d       # Start services
docker-compose down        # Stop & remove
docker-compose logs -f     # View logs
docker-compose ps          # List services
docker-compose exec svc sh # Execute command
```

---

## 🎯 Next Steps

1. **Practice**: Containerize your projects
2. **Optimize**: Focus on small image sizes
3. **Security**: Scan images, don't run as root
4. **Multi-stage**: Use for production builds
5. **Lanjut**: `/04-cicd-basics`

---

## 📚 Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Hub](https://hub.docker.com/)
- [Dockerfile Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Play with Docker](https://labs.play-with-docker.com/)

---

**Selamat! Anda sudah menguasai Docker! 🐳**

Lanjut ke: `/04-cicd-basics`
