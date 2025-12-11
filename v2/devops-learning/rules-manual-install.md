# DevOps Learning Rules - Manual Installation Guide

> **CATATAN**: File ini berisi konten untuk rules yang perlu ditambahkan secara manual ke `.agent/rules/rule.md` karena file tersebut dilindungi oleh gitignore.

## Cara Instalasi

1. Buka file `.agent/rules/rule.md` di text editor
2. Copy seluruh konten di bawah garis ini ke dalam file tersebut
3. Save file

---

# DevOps Learning Rules

## Prinsip Pembelajaran

### 1. Pendekatan Praktis
- Selalu sertakan contoh praktis dan hands-on untuk setiap konsep
- Prioritaskan learning-by-doing daripada teori saja
- Setiap topik harus disertai dengan lab/exercise yang bisa langsung dipraktikkan

### 2. Dokumentasi
- Semua konfigurasi harus terdokumentasi dengan jelas
- Gunakan comment yang menjelaskan "mengapa" bukan hanya "apa"
- Simpan semua command dan script yang penting untuk referensi

### 3. Best Practices
- Selalu ikuti industry best practices
- Jelaskan security implications dari setiap konfigurasi
- Pertimbangkan scalability dan maintainability

## Standar Teknis

### Version Control (Git)
- Gunakan conventional commits: `type(scope): description`
- Selalu buat `.gitignore` yang proper
- Branch naming: `feature/`, `bugfix/`, `hotfix/`

### Infrastructure as Code (IaC)
- Gunakan Terraform atau CloudFormation untuk AWS
- Kubernetes manifests harus menggunakan YAML
- Semua infrastructure code harus di-version control

### CI/CD
- Pipeline harus fail-fast
- Setiap stage harus punya clear purpose
- Include testing di setiap pipeline

### Containerization
- Gunakan multi-stage builds untuk Docker
- Image harus se-kecil mungkin (Alpine base jika memungkinkan)
- Scan images untuk vulnerabilities

### Configuration Management
- Gunakan Ansible untuk automation
- Playbooks harus idempotent
- Gunakan roles untuk reusability

### Monitoring & Logging
- Implement logging sejak awal
- Gunakan structured logging (JSON format)
- Setup alerting untuk critical metrics

## Prinsip Keamanan

- **Never** commit secrets atau credentials ke Git
- Gunakan environment variables atau secret management tools
- Implementasikan least privilege access
- Selalu update dependencies untuk patch security vulnerabilities

## Bahasa & Format

- Komentar dalam Bahasa Indonesia untuk kemudahan pemahaman
- Documentation bisa bilingual (ID/EN)
- Gunakan Bahasa Indonesia untuk penjelasan konsep yang rumit

## Progression Path

### Fase 1: Fundamentals (Minggu 1-4)
- Linux basics & command line
- Git & version control
- Networking fundamentals
- Scripting (Bash/Python)

### Fase 2: Core DevOps (Minggu 5-12)
- Docker & containerization
- CI/CD concepts & tools (Jenkins/GitLab CI/GitHub Actions)
- Infrastructure as Code (Terraform)
- Configuration Management (Ansible)

### Fase 3: Cloud & Orchestration (Minggu 13-20)
- AWS/GCP/Azure fundamentals
- Kubernetes & container orchestration
- Cloud-native architecture
- Service mesh basics

### Fase 4: Advanced Topics (Minggu 21-24)
- Monitoring & Observability (Prometheus, Grafana, ELK)
- Security & Compliance (DevSecOps)
- GitOps practices
- Performance optimization

## Tips Belajar

- Fokus pada satu tool/teknologi sampai paham sebelum lanjut
- Buat project real untuk praktik (deploy aplikasi sederhana end-to-end)
- Join komunitas DevOps untuk belajar dari praktisi
- Ikuti perkembangan terbaru di industri
