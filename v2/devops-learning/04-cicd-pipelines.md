# Materi Pembelajaran: CI/CD Pipeline with GitHub Actions

> **Workflow**: `/04-cicd-basics`  
> **Durasi**: 4-5 jam  
> **Level**: Intermediate  
> **Prerequisites**: Git, Docker basics

---

## 📚 Daftar Isi

1. [Pengenalan CI/CD](#pengenalan-cicd)
2. [GitHub Actions](#github-actions)
3. [GitLab CI/CD](#gitlab-cicd)
4. [Jenkins Basics](#jenkins-basics)
5. [Testing in CI/CD](#testing-cicd)
6. [Docker Integration](#docker-integration)
7. [Deployment Strategies](#deployment-strategies)
8. [Hands-On Exercises](#exercises)
9. [Troubleshooting](#troubleshooting)

---

## 1. Pengenalan CI/CD

### Apa itu CI/CD?

**CI (Continuous Integration)**:
- Automatically test code changes
- Merge code frequently
- Detect bugs early
- Build artifacts automatically

**CD (Continuous Deployment)**:
- Automatically deploy to production
- Or Continuous Delivery (deploy on approval)
- Reduce manual deployment
- Faster releases

### Traditional vs CI/CD

**Traditional**:
```
Code → Manual Testing → Manual Build → Manual Deploy
     (days/weeks)
```

**CI/CD**:
```
Code → Auto Test → Auto Build → Auto Deploy
     (minutes)
```

### Benefits

✅ **Faster delivery**: Deploy multiple times per day  
✅ **Quality**: Automated testing catches bugs  
✅ **Reduced risk**: Small, incremental changes  
✅ **Efficiency**: No manual repetitive tasks  
✅ **Feedback**: Immediate notification of issues

### CI/CD Pipeline Stages

```
┌──────────┐   ┌──────────┐   ┌──────────┐   ┌──────────┐
│  Source  │ → │   Build  │ → │   Test   │ → │  Deploy  │
└──────────┘   └──────────┘   └──────────┘   └──────────┘
  git push      compile code    unit tests    production
                build docker    integration   staging
                                lint/security
```

---

## 2. GitHub Actions

### Apa itu GitHub Actions?

CI/CD platform terintegrasi dengan GitHub.

**Features**:
- Free for public repos
- YAML-based configuration
- Marketplace dengan 10,000+ actions
- Matrix builds (multiple OS/versions)

### Workflow Structure

```yaml
name: CI Pipeline        # Workflow name

on: [push, pull_request] # Triggers

jobs:                    # Jobs to run
  build:
    runs-on: ubuntu-latest  # Runner OS
    steps:                  # Steps in job
      - uses: actions/checkout@v4
      - run: npm install
```

### Basic CI Workflow

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Setup Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linter
      run: npm run lint
    
    - name: Run tests
      run: npm test
    
    - name: Build
      run: npm run build
```

### Docker Build & Push

```yaml
name: Docker Build

on:
  push:
    branches: [ main ]
    tags:
      - 'v*'

env:
  REGISTRY: docker.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    permissions:
      contents: read
      packages: write
    
    steps:
    - name: Checkout
      uses: actions/checkout@v4
    
    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v3
    
    - name: Login to Docker Hub
      uses: docker/login-action@v3
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
    
    - name: Extract metadata
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=semver,pattern={{version}}
          type=sha
    
    - name: Build and push
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        cache-from: type=gha
        cache-to: type=gha,mode=max
```

### Matrix Strategy

```yaml
name: Test Matrix

on: [push, pull_request]

jobs:
  test:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, windows-latest, macos-latest]
        node-version: [16, 18, 20]
    
    steps:
    - uses: actions/checkout@v4
    
    - name: Setup Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v4
      with:
        node-version: ${{ matrix.node-version }}
    
    - run: npm ci
    - run: npm test
```

### Secrets Management

```yaml
# Use secrets in workflow
env:
  API_KEY: ${{ secrets.API_KEY }}
  DB_PASSWORD: ${{ secrets.DB_PASSWORD }}

steps:
  - name: Deploy
    run: |
      echo "Deploying with API key: $API_KEY"
```

**Add secrets**:
1. GitHub → Repository → Settings
2. Secrets and variables → Actions
3. New repository secret

---

## 3. GitLab CI/CD

### .gitlab-ci.yml Structure

```yaml
stages:          # Pipeline stages
  - build
  - test
  - deploy

variables:       # Global variables
  VAR_NAME: value

build-job:       # Job definition
  stage: build
  script:
    - echo "Building..."
  rules:
    - if: $CI_COMMIT_BRANCH == "main"
```

### Complete Example

```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  IMAGE_NAME: $CI_REGISTRY_IMAGE:$CI_COMMIT_SHORT_SHA

# Test stage
test:
  stage: test
  image: node:18-alpine
  script:
    - npm ci
    - npm run lint
    - npm test
  coverage: '/Coverage: \d+\.\d+/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
  only:
    - merge_requests
    - main

# Build Docker image
build:
  stage: build
  image: docker:24-dind
  services:
    - docker:24-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $IMAGE_NAME .
    - docker push $IMAGE_NAME
  only:
    - main

# Deploy to staging
deploy-staging:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$SSH_PRIVATE_KEY" | ssh-add -
  script:
    - ssh user@staging-server "docker pull $IMAGE_NAME"
    - ssh user@staging-server "docker stop myapp || true"
    - ssh user@staging-server "docker rm myapp || true"
    - ssh user@staging-server "docker run -d --name myapp -p 80:80 $IMAGE_NAME"
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - main

# Deploy to production
deploy-production:
  stage: deploy
  extends: deploy-staging
  script:
    - ssh user@prod-server "docker pull $IMAGE_NAME"
    - ssh user@prod-server "docker stop myapp || true"
    - ssh user@prod-server "docker rm myapp || true"
    - ssh user@prod-server "docker run -d --name myapp -p 80:80 $IMAGE_NAME"
  environment:
    name: production
    url: https://example.com
  when: manual
  only:
    - main
```

### GitLab CI Variables

```yaml
variables:
  # Project variables
  API_URL: "https://api.example.com"
  
  # Predefined variables
  # $CI_COMMIT_SHA - commit hash
  # $CI_COMMIT_BRANCH - branch name
  # $CI_PIPELINE_ID - pipeline ID
  # $CI_REGISTRY - GitLab registry URL
```

---

## 4. Jenkins Basics

### Jenkinsfile (Declarative)

```groovy
pipeline {
    agent any
    
    environment {
        DOCKER_REGISTRY = 'docker.io'
        IMAGE_NAME = 'myapp'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm ci'
                sh 'npm run lint'
                sh 'npm test'
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }
        
        stage('Docker Build') {
            steps {
                script {
                    docker.build("${IMAGE_NAME}:${BUILD_NUMBER}")
                }
            }
        }
        
        stage('Docker Push') {
            steps {
                script {
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-credentials') {
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push()
                        docker.image("${IMAGE_NAME}:${BUILD_NUMBER}").push('latest')
                    }
                }
            }
        }
        
        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    ssh user@server "docker pull ${IMAGE_NAME}:latest"
                    ssh user@server "docker stop myapp || true"
                    ssh user@server "docker rm myapp || true"
                    ssh user@server "docker run -d --name myapp -p 80:80 ${IMAGE_NAME}:latest"
                '''
            }
        }
    }
    
    post {
        success {
            echo 'Pipeline succeeded!'
            // Send notification
        }
        failure {
            echo 'Pipeline failed!'
            // Send alert
        }
        always {
            cleanWs()
        }
    }
}
```

---

## 5. Testing in CI/CD

### Test Pyramid

```
        ┌───────────┐
        │    E2E    │  ← Few, slow, expensive
        ├───────────┤
        │Integration│  ← Some
        ├───────────┤
        │   Unit    │  ← Many, fast, cheap
        └───────────┘
```

### Unit Tests

```yaml
# GitHub Actions
- name: Unit Tests
  run: |
    npm test
    npm run test:coverage
```

### Integration Tests

```yaml
- name: Integration Tests
  run: |
    docker-compose up -d
    npm run test:integration
    docker-compose down
```

### E2E Tests

```yaml
- name: E2E Tests
  run: |
    npm run start:test &
    npx wait-on http://localhost:3000
    npm run test:e2e
```

### Code Quality

```yaml
# Linting
- name: Lint
  run: npm run lint

# Code coverage
- name: Coverage
  run: |
    npm test -- --coverage
    npx codecov

# Security scan
- name: Security Scan
  run: npm audit

# SAST
- name: SonarQube Scan
  uses: sonarsource/sonarqube-scan-action@master
```

---

## 6. Docker Integration

### Build Multi-Platform Images

```yaml
- name: Build multi-platform
  uses: docker/build-push-action@v5
  with:
    platforms: linux/amd64,linux/arm64
    push: true
    tags: myapp:latest
```

### Image Scanning

```yaml
- name: Scan image
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: 'myapp:latest'
    format: 'sarif'
    output: 'trivy-results.sarif'
```

### Docker Compose in CI

```yaml
- name: Start services
  run: docker-compose up -d

- name: Run tests
  run: docker-compose exec -T api pytest

- name: Cleanup
  run: docker-compose down -v
```

---

## 7. Deployment Strategies

### Blue-Green Deployment

```yaml
deploy:
  script:
    # Deploy to green
    - deploy_to_green
    # Run smoke tests
    - test_green
    # Switch traffic
    - switch_to_green
    # Keep blue as backup
```

### Canary Deployment

```yaml
deploy-canary:
  script:
    # Deploy to 10% traffic
    - deploy_canary 10
    # Monitor metrics
    - check_metrics
    # Increase to 50%
    - deploy_canary 50
    # Full rollout
    - deploy_canary 100
```

### Rolling Update

```yaml
deploy:
  script:
    # Update instances one by one
    - for server in $SERVERS; do
        deploy_to $server
        wait_healthy $server
      done
```

---

## 8. Hands-On Exercises

### Exercise 1: Simple CI Pipeline

Create `.github/workflows/ci.yml`:

```yaml
name: Simple CI

on:
  push:
    branches: [ main ]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install
        run: npm ci
      
      - name: Test
        run: npm test
      
      - name: Build
        run: npm run build
```

**Test**:
1. Push to GitHub
2. Check Actions tab
3. View workflow run

---

### Exercise 2: Docker Build & Push

```yaml
name: Docker

on:
  push:
    branches: [ main ]

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Login
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      
      - name: Build & Push
        uses: docker/build-push-action@v5
        with:
          push: true
          tags: username/myapp:latest
```

**Setup**:
1. Add Docker Hub credentials to secrets
2. Push to trigger build
3. Check Docker Hub for image

---

### Exercise 3: Full Pipeline

Complete pipeline with all stages:

```yaml
name: Full Pipeline

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
      - run: npm ci
      - run: npm run lint
      - run: npm test
  
  build:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
      - uses: docker/build-push-action@v5
        with:
          push: true
          tags: username/myapp:${{ github.sha }}
  
  deploy:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to server
        run: |
          echo "Deploying to production..."
          # Add deployment commands
```

---

## 9. Troubleshooting

### Issue 1: Workflow Not Triggering

**Check**:
- Correct file path: `.github/workflows/`
- Valid YAML syntax
- Branch protection rules
- Webhook settings

---

### Issue 2: Permission Denied

**Solution**:
```yaml
permissions:
  contents: read
  packages: write
```

---

### Issue 3: Secrets Not Working

**Verify**:
- Secret name matches exactly
- No typos in `${{ secrets.NAME }}`
- Secret is set in correct repository

---

## 📝 CI/CD Best Practices

✅ **Fail fast**: Run tests before build  
✅ **Cache dependencies**: Speed up builds  
✅ **Parallel jobs**: Run independent steps concurrently  
✅ **Security**: Scan for vulnerabilities  
✅ **Notifications**: Alert on failures  
✅ **Documentation**: Comment complex steps  

---

## 🎯 Next Steps

1. **Implement CI/CD** for your projects
2. **Add testing** at all levels
3. **Automate deployment** to staging
4. **Monitor pipelines** and optimize
5. **Lanjut**: `/05-kubernetes-basics`

---

## 📚 Resources

- [GitHub Actions Docs](https://docs.github.com/actions)
- [GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)

---

**Selamat! CI/CD pipeline siap! 🚀**

Lanjut ke: `/05-kubernetes-basics`
