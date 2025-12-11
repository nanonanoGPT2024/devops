# DevOps Learning Path: Beginner to Advanced

Dokumen ini adalah roadmap lengkap pembelajaran DevOps dari dasar hingga mahir.

## Learning Philosophy

> **DevOps adalah budaya, bukan hanya tools**
> 
> Fokus pada pemahaman prinsip, automation, collaboration, dan continuous improvement

## Prerequisites

### Fundamental Skills (1-2 Minggu)
- [x] Basic command line (Linux/Unix)
- [x] Text editor (Vim/Nano/VSCode)
- [x] Basic programming (Python/Bash/JavaScript)
- [x] Understanding of web applications (HTTP, APIs, databases)

### Recommended Setup
- **OS**: Linux (Ubuntu/Debian) atau WSL untuk Windows
- **Hardware**: Minimal 8GB RAM, 50GB storage
- **Tools**: Git, Docker, kubectl, text editor

## Phase 1: Fundamentals (Bulan 1)

### Week 1: Linux & Command Line
**Workflow**: `/01-setup-linux-env`

**Topics**:
- Linux file system structure
- Essential commands (ls, cd, grep, find, chmod, etc)
- Text manipulation (cat, sed, awk)
- Process management (ps, top, kill)
- Networking basics (ping, netstat, curl)
- Bash scripting fundamentals

**Practice Projects**:
1. Buat script untuk backup otomatis
2. Script untuk monitoring disk usage
3. Log analysis dengan grep/awk

**Resources**:
- LinuxJourney.com
- OverTheWire Bandit (hands-on practice)

---

### Week 2: Version Control with Git
**Workflow**: `/02-git-basics`

**Topics**:
- Git fundamentals (init, add, commit, push, pull)
- Branching strategies (Git Flow, GitHub Flow)
- Merge vs Rebase
- Conflict resolution
- GitHub/GitLab usage
- Pull requests & code review

**Practice Projects**:
1. Contribute to open source project
2. Setup GitHub Pages
3. Practice branching strategies

**Resources**:
- Pro Git Book (gratis)
- Learn Git Branching (interactive)

---

### Week 3-4: Scripting & Automation
**Topics**:
- Advanced Bash scripting
- Python for automation
- YAML & JSON
- Regular expressions
- Cron jobs

**Practice Projects**:
1. System health monitoring script
2. Automated deployment script
3. Log aggregation tool

## Phase 2: Core DevOps (Bulan 2-3)

### Week 5-6: Containerization with Docker
**Workflow**: `/03-docker-basics`

**Topics**:
- Container fundamentals
- Docker architecture
- Dockerfile best practices
- Multi-stage builds
- Docker Compose
- Docker networking & volumes
- Image optimization
- Security scanning

**Practice Projects**:
1. Containerize full-stack application
2. Multi-container app dengan Docker Compose
3. Optimize image size (< 100MB untuk Python/Node app)

**Resources**:
- Docker Docs
- Play with Docker

---

### Week 7-8: CI/CD Pipelines
**Workflow**: `/04-cicd-basics`

**Topics**:
- CI/CD concepts
- GitHub Actions
- GitLab CI/CD
- Jenkins (optional)
- Pipeline as Code
- Testing automation
- Artifact management

**Practice Projects**:
1. Setup CI pipeline dengan automated tests
2. CD pipeline untuk Docker image
3. Multi-environment deployment (dev/staging/prod)

**Resources**:
- GitHub Actions Docs
- GitLab CI/CD Docs

---

### Week 9-10: Infrastructure as Code
**Topics**:
- IaC concepts
- Terraform basics
- HCL syntax
- State management
- Modules & providers
- Cloud platforms (AWS/GCP/Azure)

**Practice Projects**:
1. Terraform untuk AWS VPC & EC2
2. Module untuk reusable infrastructure
3. Multi-environment dengan Terraform workspaces

**Resources**:
- HashiCorp Learn
- Terraform Registry

---

### Week 11-12: Configuration Management
**Topics**:
- Ansible fundamentals
- Playbooks & roles
- Inventory management
- Idempotency
- Ansible Galaxy
- Jinja2 templating

**Practice Projects**:
1. Automate server setup dengan Ansible
2. Deploy aplikasi multi-tier
3. Rolling updates dengan zero downtime

**Resources**:
- Ansible Docs
- Ansible for DevOps Book

## Phase 3: Cloud & Orchestration (Bulan 4-5)

### Week 13-14: Cloud Fundamentals
**Topics**:
- Cloud computing models (IaaS, PaaS, SaaS)
- AWS/GCP/Azure core services
- Compute (EC2, VMs)
- Storage (S3, EBS)
- Networking (VPC, Load Balancers)
- IAM & Security
- Cost optimization

**Practice Projects**:
1. Deploy 3-tier app di AWS
2. Setup auto-scaling group
3. S3 + CloudFront untuk static site

**Certification Path**:
- AWS Certified Cloud Practitioner
- AWS Solutions Architect Associate

---

### Week 15-18: Kubernetes
**Workflow**: `/05-kubernetes-basics`

**Topics**:
- Container orchestration concepts
- K8s architecture
- Pods, Deployments, Services
- ConfigMaps & Secrets
- Volumes & StatefulSets
- Ingress Controllers
- Helm package manager
- Kubernetes networking
- RBAC & security

**Practice Projects**:
1. Deploy microservices di K8s
2. Implement service mesh (Istio)
3. GitOps dengan ArgoCD
4. Multi-environment setup

**Resources**:
- Kubernetes Docs
- Kubernetes The Hard Way
- KillerCoda K8s Scenarios

---

### Week 19-20: Advanced K8s
**Topics**:
- Operators & CRDs
- Monitoring dengan Prometheus
- Logging dengan EFK stack
- Auto-scaling (HPA, VPA, Cluster Autoscaler)
- Service Mesh (Istio/Linkerd)
- Security best practices

**Practice Projects**:
1. Custom operator untuk aplikasi
2. Complete observability stack
3. Multi-cluster management

**Certification Path**:
- CKA (Certified Kubernetes Administrator)
- CKAD (Certified Kubernetes Application Developer)

## Phase 4: Advanced DevOps (Bulan 6)

### Week 21-22: Monitoring & Observability
**Topics**:
- The three pillars: Logs, Metrics, Traces
- Prometheus & Grafana
- ELK/EFK Stack
- Distributed tracing (Jaeger)
- APM tools
- Alerting strategies
- SLI, SLO, SLA

**Practice Projects**:
1. Complete monitoring stack
2. Custom Grafana dashboards
3. Alert management dengan Alertmanager

**Resources**:
- Prometheus Docs
- Grafana Tutorials

---

### Week 23: Security (DevSecOps)
**Topics**:
- Security in DevOps lifecycle
- Secret management (Vault, Sealed Secrets)
- Container scanning
- SAST & DAST
- Security policies (OPA)
- Compliance & auditing
- Network policies
- Zero-trust architecture

**Practice Projects**:
1. Implement Vault untuk secrets
2. Setup security scanning di CI/CD
3. Network policies di K8s

**Resources**:
- OWASP Top 10
- DevSecOps Best Practices

---

### Week 24: GitOps & Platform Engineering
**Topics**:
- GitOps principles
- FluxCD/ArgoCD
- Internal Developer Platforms
- Self-service infrastructure
- Platform as a Product
- Developer Experience

**Practice Projects**:
1. GitOps workflow dengan ArgoCD
2. Self-service platform untuk developers
3. Golden path templates

## Continuous Learning Topics

### After 6 Months
- **Advanced Networking**: Service mesh, CNI, load balancing
- **Chaos Engineering**: Litmus, Chaos Mesh
- **Cost Optimization**: FinOps practices
- **Multi-cloud**: Strategy & implementation
- **Edge Computing**: K3s, edge deployments
- **Serverless**: Lambda, Cloud Functions
- **Database Operations**: DBaaS, migrations, backups

## Practical Project: E-Commerce Platform

Aplikasikan semua skill dengan build end-to-end platform:

### Phase 1: Application
- Microservices architecture
- Frontend (React/Vue)
- Backend APIs (Node.js/Python/Go)
- Databases (PostgreSQL, Redis)

### Phase 2: Infrastructure
- Terraform untuk AWS/GCP
- Kubernetes cluster (EKS/GKE)
- Service mesh (Istio)

### Phase 3: CI/CD
- GitHub Actions untuk CI
- ArgoCD untuk CD
- Multi-environment deployment

### Phase 4: Observability
- Prometheus + Grafana
- ELK untuk logs
- Jaeger untuk tracing

### Phase 5: Security
- Vault untuk secrets
- Security scanning
- Network policies

## Learning Strategy

### Daily Routine (Recommended)
- **1-2 jam teori**: Baca docs, watch videos
- **2-3 jam praktik**: Hands-on labs
- **30 menit review**: Document learnings

### Weekly Goals
- Complete 1 workflow
- Build 1 project
- Write 1 blog post/documentation

### Monthly Milestones
- Complete 1 phase
- Deploy 1 production-like project
- Share knowledge (meetup/blog)

## Community & Resources

### Communities
- Reddit: r/devops, r/kubernetes
- Discord: DevOps Indonesia
- LinkedIn Groups
- Local meetups

### Blogs & Newsletters
- DevOps Weekly
- CNCF Blog
- AWS Blog
- Kubernetes Blog

### Practice Platforms
- KillerCoda
- Katacoda
- Play with Docker
- Play with Kubernetes

### YouTube Channels
- TechWorld with Nana
- Network Chuck
- Cloud Native Computing Foundation

## Certification Roadmap

### Entry Level
1. **Linux Foundation Certified System Administrator (LFCS)**
2. **AWS Certified Cloud Practitioner**

### Intermediate
3. **AWS Solutions Architect Associate**
4. **Certified Kubernetes Administrator (CKA)**
5. **HashiCorp Certified Terraform Associate**

### Advanced
6. **Certified Kubernetes Application Developer (CKAD)**
7. **AWS DevOps Engineer Professional**
8. **Certified Kubernetes Security Specialist (CKS)**

## Success Metrics

Track your progress:

- [ ] Bisa setup Linux server dari scratch
- [ ] Bisa containerize aplikasi
- [ ] Bisa deploy ke Kubernetes
- [ ] Bisa setup CI/CD pipeline
- [ ] Bisa provision infrastructure dengan code
- [ ] Bisa implement monitoring
- [ ] Bisa troubleshoot production issues
- [ ] Contribute ke open source project
- [ ] Build portfolio project
- [ ] Get DevOps certification

## Tips Sukses

1. **Praktik lebih banyak dari teori** (70% praktik, 30% teori)
2. **Build portfolio** dengan project real di GitHub
3. **Document your learning** dalam blog/notes
4. **Join community** untuk networking dan belajar
5. **Stay updated** dengan teknologi terbaru
6. **Jangan takut gagal** - troubleshooting adalah pembelajaran terbaik
7. **Fokus pada fundamentals** sebelum tools
8. **Automate everything** yang bisa di-automate
9. **Think like a developer** - code quality matters
10. **Think like an operator** - reliability matters

## Next Steps

1. **Sekarang**: Mulai dengan `/01-setup-linux-env`
2. **Minggu ini**: Selesaikan Linux fundamentals
3. **Bulan ini**: Selesaikan Phase 1
4. **3 Bulan**: Selesaikan Phase 2
5. **6 Bulan**: Selesaikan Phase 4 dan mulai job hunting

---

**Remember**: DevOps adalah journey, bukan destination. Terus belajar, terus berkembang! 🚀
