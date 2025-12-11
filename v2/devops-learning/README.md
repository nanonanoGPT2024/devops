# DevOps Learning Documentation

> **Status**: ✅ Complete - 12 Topics in 9 Documents  
> **Total Materials**: 9 Comprehensive Documents (300+ pages)  
> **Workflows**: 5 Hands-on Workflows  
> **Coverage**: Beginner to Expert Level

Dokumentasi lengkap untuk pembelajaran DevOps dari dasar hingga mahir.

## 📚 Daftar Dokumen

### 1. [Walkthrough](./walkthrough.md)
**Mulai dari sini!** Overview lengkap setup pembelajaran DevOps, daftar semua materi, dan cara menggunakan resources.

### 2. [Prompt Guide](./prompt-guide.md)
Panduan membuat prompt yang efektif untuk belajar DevOps:
- Template untuk berbagai skenario
- Formula 5W1H
- Contoh prompt yang baik vs buruk
- Anti-patterns yang harus dihindari

### 3. [Learning Path](./learning-path.md)
Roadmap belajar 6 bulan dari beginner ke expert:
- **Phase 1**: Fundamentals (Bulan 1)
- **Phase 2**: Core DevOps (Bulan 2-3)
- **Phase 3**: Cloud & Orchestration (Bulan 4-5)
- **Phase 4**: Advanced Topics (Bulan 6)

### 4. [Rules Manual Install](./rules-manual-install.md)
Konten rules untuk ditambahkan ke `.agent/rules/rule.md`

## 🚀 Quick Start

### Langkah 1: Install Rules
Buka `.agent/rules/rule.md` dan copy konten dari [rules-manual-install.md](./rules-manual-install.md)

### Langkah 2: Mulai Workflow
```
/01-setup-linux-env
```

### Langkah 3: Ikuti Learning Path
Baca [learning-path.md](./learning-path.md) untuk schedule lengkap

## 📂 Learning Materials (9 Documents = 12 Topics)

### Phase 1: Fundamentals (3 Topics)

**1. Linux Environment Setup** (30+ pages)
- `/01-setup-linux-env` workflow
- 📖 [Materi Lengkap](./01-linux-environment-setup.md)
- WSL2 setup, Linux commands, package management, Git, Docker, SSH

**2. Git Version Control** (35+ pages)
- `/02-git-basics` workflow
- 📖 [Materi Lengkap](./02-git-version-control.md)
- Git workflow, branching, merging, conventional commits, remote repos

**3. Bash & Python Scripting** (25+ pages)
- 📖 [Materi Lengkap](./06-scripting-automation.md)
- Bash fundamentals, advanced bash, Python for DevOps, automation examples

---

### Phase 2: Core DevOps (4 Topics)

**4. Docker Containerization** (40+ pages)
- `/03-docker-basics` workflow
- 📖 [Materi Lengkap](./03-docker-containerization.md)
- Images, containers, Dockerfile best practices, multi-stage builds, Docker Compose

**5. CI/CD Pipelines** (30+ pages)
- `/04-cicd-basics` workflow
- 📖 [Materi Lengkap](./04-cicd-pipelines.md)
- GitHub Actions, GitLab CI, Jenkins, testing strategies, deployment patterns

**6. Terraform - Infrastructure as Code** (25+ pages)
- 📖 [Materi Lengkap](./07-terraform-iac.md)
- IaC concepts, Terraform fundamentals, state management, modules, AWS examples

**7. Ansible - Configuration Management** (30+ pages)
- 📖 [Materi Lengkap](./09-ansible-config-mgmt.md)
- Ansible fundamentals, playbooks, roles, inventory, real automation examples

---

### Phase 3: Cloud & Kubernetes (2 Topics)

**8. Kubernetes Orchestration** (45+ pages)
- `/05-kubernetes-basics` workflow
- 📖 [Materi Lengkap](./05-kubernetes-orchestration.md)
- Architecture, pods, deployments, services, ConfigMaps, secrets, volumes, HPA, Ingress

**9. Cloud Platforms** - *Part of Advanced DevOps* (15+ pages)
- 📖 See [08-advanced-devops.md Part 1](./08-advanced-devops.md)
- AWS fundamentals: EC2, S3, RDS, VPC, CLI operations

---

### Phase 4: Advanced Topics (3 Topics in 1 Document)

**📖 [Advanced DevOps Topics](./08-advanced-devops.md)** (40+ pages total)

This document combines 3 advanced topics:

**10. Monitoring & Observability** (Part 2)
- Prometheus + Grafana stack
- ELK Stack for logs
- PromQL queries, custom metrics
- Application monitoring

**11. DevSecOps & Security** (Part 3)
- Secret management with Vault
- Container security scanning (Trivy)
- Dockerfile security best practices
- Kubernetes RBAC & Network Policies

**12. GitOps with ArgoCD** (Part 4)
- GitOps concepts
- ArgoCD installation & configuration
- Kustomize for multi-environment
- Automated deployments

---

## 📊 Coverage Summary

| Phase | Topics | Documents | Pages | Status |
|-------|--------|-----------|-------|--------|
| **Phase 1** | 3 | 3 files | 90+ | ✅ Complete |
| **Phase 2** | 4 | 4 files | 125+ | ✅ Complete |
| **Phase 3** | 2 | 1.5 files | 60+ | ✅ Complete |
| **Phase 4** | 3 | 0.5 file | 40+ | ✅ Complete |
| **TOTAL** | **12** | **9 files** | **300+** | ✅ **100%** |

## 💡 Tips

1. **Mulai sequential** - Jangan skip basics
2. **Praktik daily** - 1-2 jam per hari
3. **Build portfolio** - Buat project real
4. **Join community** - Belajar dari praktisi

## 📖 Files Index

```
docs/devops-learning/
├── README.md                           # ← You are here
├── walkthrough.md                      # Complete overview
├── prompt-guide.md                     # Prompt engineering guide
├── learning-path.md                    # 6-month roadmap
├── rules-manual-install.md             # Rules content
├── 01-linux-environment-setup.md       # Topic 1
├── 02-git-version-control.md           # Topic 2
├── 03-docker-containerization.md       # Topic 4
├── 04-cicd-pipelines.md                # Topic 5
├── 05-kubernetes-orchestration.md      # Topic 8
├── 06-scripting-automation.md          # Topic 3
├── 07-terraform-iac.md                 # Topic 6
├── 08-advanced-devops.md               # Topics 9, 10, 11, 12
└── 09-ansible-config-mgmt.md           # Topic 7
```

Happy learning! 🎓
