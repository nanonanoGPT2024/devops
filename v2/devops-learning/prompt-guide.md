# Panduan Prompt yang Efektif untuk Pembelajaran DevOps

## Prinsip Dasar Prompt yang Baik

### 1. **Spesifik dan Jelas**
❌ **Buruk**: "Tolong bantu saya dengan Docker"
✅ **Baik**: "Tolong bantu saya membuat Dockerfile multi-stage untuk aplikasi Node.js dengan optimasi ukuran image"

### 2. **Berikan Konteks**
❌ **Buruk**: "Kenapa error?"
✅ **Baik**: "Saya mendapat error 'connection refused' saat mencoba deploy aplikasi ke Kubernetes cluster Minikube. Berikut log errornya: [paste log]"

### 3. **Satu Fokus Per Request**
❌ **Buruk**: "Setup Docker, Kubernetes, CI/CD, dan monitoring sekaligus"
✅ **Baik**: "Tolong bantu setup Docker terlebih dahulu, setelah itu kita lanjut ke Kubernetes"

### 4. **Jelaskan Tujuan Akhir**
❌ **Buruk**: "Buatkan Dockerfile"
✅ **Baik**: "Buatkan Dockerfile untuk production deployment aplikasi Flask yang perlu optimasi ukuran dan keamanan"

## Template Prompt untuk Berbagai Skenario

### Skenario 1: Mempelajari Konsep Baru
```
Saya ingin belajar [teknologi/konsep] untuk [tujuan].
Saat ini level saya [pemula/menengah/mahir].
Tolong jelaskan dengan [pendekatan hands-on/teori dulu/contoh praktis].
```

**Contoh:**
```
Saya ingin belajar Kubernetes untuk deploy microservices.
Saat ini level saya pemula dalam container orchestration.
Tolong jelaskan dengan pendekatan hands-on mulai dari setup cluster lokal.
```

### Skenario 2: Troubleshooting
```
Saya mengalami masalah: [deskripsi masalah]
Yang sudah saya coba: [langkah-langkah]
Environment: [OS, versi tool, dll]
Error message: [paste error]
```

**Contoh:**
```
Saya mengalami masalah: Pod Kubernetes tidak bisa pull image dari private registry
Yang sudah saya coba: 
- Membuat docker-registry secret
- Menambahkan imagePullSecrets di deployment
Environment: Minikube v1.32, Kubernetes v1.28, Docker Hub private registry
Error message: "ErrImagePull: failed to pull image"
```

### Skenario 3: Code Review / Optimasi
```
Tolong review [jenis file/konfigurasi] ini untuk [aspek yang ingin direview].
Focus pada: [performance/security/best practices]
[Paste code/config]
```

**Contoh:**
```
Tolong review Dockerfile ini untuk optimasi ukuran dan security.
Focus pada: best practices production dan vulnerabilities
[Paste Dockerfile]
```

### Skenario 4: Implementasi Fitur
```
Saya perlu [fitur/fungsionalitas] untuk [use case].
Requirements:
- [requirement 1]
- [requirement 2]
Constraints: [batasan teknologi/resource]
```

**Contoh:**
```
Saya perlu CI/CD pipeline untuk auto-deploy aplikasi Node.js ke AWS ECS.
Requirements:
- Auto test setiap push ke branch develop
- Deploy ke staging jika test pass
- Deploy ke production hanya jika ada tag release
Constraints: Menggunakan GitHub Actions, budget minimal
```

### Skenario 5: Meminta Best Practices
```
Apa best practice untuk [topik] dalam konteks [use case]?
Khususnya untuk [aspek spesifik]
```

**Contoh:**
```
Apa best practice untuk secret management dalam Kubernetes production?
Khususnya untuk credentials database dan API keys
```

## Formula "5W1H" untuk Prompt Kompleks

### What (Apa)
Apa yang ingin Anda capai/pelajari?

### Why (Mengapa)
Mengapa Anda membutuhkannya? Apa use case-nya?

### When (Kapan)
Timeline atau urgency?

### Where (Dimana)
Environment apa? (local/staging/production)

### Who (Siapa)
Untuk tim berapa besar? Skill level tim?

### How (Bagaimana)
Bagaimana approach yang Anda inginkan?

**Contoh Lengkap:**
```
WHAT: Setup monitoring stack untuk microservices
WHY: Untuk detect performance issues dan troubleshooting
WHEN: Perlu selesai dalam 2 minggu
WHERE: Production Kubernetes cluster di AWS EKS
WHO: Tim 3 orang dengan basic k8s knowledge
HOW: Prefer open-source tools, integrasi dengan existing Grafana
```

## Prompt Bertahap (Iteratif)

### Tahap 1: Overview
"Tolong jelaskan high-level architecture untuk [sistem yang ingin dibangun]"

### Tahap 2: Deep Dive
"Untuk component [X] yang tadi dijelaskan, tolong detail implementasinya"

### Tahap 3: Implementation
"Tolong bantu implement [component X] dengan [spesifikasi]"

### Tahap 4: Verification
"Bagaimana cara verify bahwa [component X] sudah berjalan dengan benar?"

## Tips Khusus untuk DevOps Learning

### Untuk Pemula
```
Gunakan workflow yang sudah ada:
- /01-setup-linux-env
- /02-git-basics
- /03-docker-basics
- dst.

Atau minta penjelasan:
"Tolong jelaskan [konsep] dengan analogi sederhana dan contoh praktis"
```

### Untuk Level Menengah
```
Minta comparison dan trade-offs:
"Apa perbedaan antara [A] vs [B]? Kapan sebaiknya pakai yang mana?"

Contoh:
"Apa perbedaan Docker Compose vs Kubernetes? Kapan sebaiknya pakai yang mana?"
```

### Untuk Level Advanced
```
Diskusi arsitektur dan optimization:
"Bagaimana design [sistem] yang scalable untuk [use case] dengan consideration [X, Y, Z]?"

Contoh:
"Bagaimana design CI/CD pipeline yang scalable untuk 50+ microservices dengan consideration multi-region deployment dan rollback strategy?"
```

## Contoh Prompt Progression untuk Satu Project

### Minggu 1: Planning
```
Saya ingin build full DevOps pipeline untuk aplikasi e-commerce.
Stack: React frontend, Node.js backend, PostgreSQL
Target: Deploy ke AWS dengan auto-scaling
Budget: Minimal cost untuk MVP

Tolong bantu buat implementation plan step-by-step
```

### Minggu 2: Infrastructure
```
Lanjutan project e-commerce kemarin.
Sekarang fokus ke infrastructure setup.
Tolong bantu setup:
1. VPC dan networking di AWS
2. RDS PostgreSQL
3. ECS cluster untuk container
Gunakan Terraform untuk IaC
```

### Minggu 3: CI/CD
```
Lanjutan project e-commerce.
Infrastructure sudah ready.
Sekarang setup CI/CD dengan GitHub Actions:
1. Build & test frontend dan backend
2. Build Docker images
3. Push ke ECR
4. Deploy ke ECS
5. Run smoke tests
```

### Minggu 4: Monitoring
```
Lanjutan project e-commerce.
App sudah running di production.
Setup monitoring dengan:
1. CloudWatch untuk logs
2. Prometheus + Grafana untuk metrics
3. Alerting ke Slack
4. Dashboard untuk business metrics
```

## Keywords yang Efektif

### Untuk Penjelasan
- "Jelaskan seperti saya berusia 5 tahun (ELI5)"
- "Dengan analogi sederhana"
- "Step-by-step dengan contoh"
- "Hands-on tutorial"

### Untuk Implementation
- "Production-ready"
- "Best practices"
- "Security consideration"
- "Dengan error handling"
- "Include testing"

### Untuk Review
- "Review untuk optimization"
- "Identify security issues"
- "Suggest improvements"
- "Compare dengan industry standards"

## Anti-Pattern (Hindari)

❌ Prompt terlalu umum
❌ Tidak memberikan konteks
❌ Mengabaikan error messages
❌ Tidak mention versi tools
❌ Asking "Kenapa tidak jalan?" tanpa detail
❌ Meminta terlalu banyak sekaligus
❌ Tidak spesifik tentang environment

## Checklist Sebelum Submit Prompt

- [ ] Apakah tujuan saya jelas?
- [ ] Sudah berikan konteks yang cukup?
- [ ] Mention versi tools yang digunakan?
- [ ] Include error message jika troubleshooting?
- [ ] Request spesifik, bukan general?
- [ ] Satu fokus utama per prompt?

## Contoh Prompt Praktis

### Belajar Kubernetes
```
Saya baru selesai belajar Docker dan ingin mulai Kubernetes.
Tolong bantu jalankan workflow /05-kubernetes-basics
Fokus ke:
1. Setup minikube
2. Deploy aplikasi hello-world
3. Expose dengan service
4. Akses dari browser

Jelaskan setiap command yang dijalankan
```

### Debugging Issue
```
Pod Kubernetes saya crash dengan CrashLoopBackOff.
Ini deployment.yaml saya:
[paste yaml]

Logs dari pod:
[paste logs]

Describe pod output:
[paste describe]

Environment: Minikube 1.32, kubectl 1.28
Aplikasi: Node.js dengan PostgreSQL connection
```

### Implementasi Feature
```
Tolong bantu implement auto-scaling untuk deployment Kubernetes saya.
Requirements:
- Scale berdasarkan CPU usage (target 70%)
- Min 2 pods, max 10 pods
- Scale up agresif, scale down konservatif

Current deployment sudah ada dengan 3 replicas manual.
Perlu preserve existing configuration.
```

## Kesimpulan

**Prompt yang baik = Hasil yang baik**

Ingat 3 prinsip utama:
1. **Spesifik**: Jelas apa yang Anda inginkan
2. **Konteks**: Berikan informasi yang relevan
3. **Fokus**: Satu topik per request

Semakin detail dan terstruktur prompt Anda, semakin akurat dan membantu respons yang akan Anda terima! 🚀
