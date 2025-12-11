# Capstone Project: The Ultimate DevOps Pipeline

Selamat! Anda sudah mempelajari semua komponen secara terpisah. Sekarang saatnya menggabungkan semuanya dalam satu proyek nyata.

## Skenario Proyek
Anda diminta membangun infrastruktur untuk aplikasi web **"Catatan Keuangan"** (Simple Python Flask App + PostgreSQL).
Tujuannya: Setiap kali developer push code ke GitHub, aplikasi harus otomatis ter-update di server production tanpa downtime.

## Arsitektur yang Akan Dibangun
1.  **Code**: Python Flask (Web) + PostgreSQL (DB).
2.  **Version Control**: GitHub.
3.  **CI (Continuous Integration)**: GitHub Actions (Test & Build Docker Image).
4.  **Registry**: Docker Hub / GitHub Container Registry.
5.  **IaC**: Terraform (Provisioning VM/K8s Cluster di AWS/Local).
6.  **CD (Continuous Deployment)**: ArgoCD atau GitHub Actions deploy ke K8s.
7.  **Monitoring**: Prometheus + Grafana dashboard.

---

## Langkah-Langkah Pengerjaan

### Tahap 1: Development (Local)
1.  Buat aplikasi Python Flask sederhana yang connect ke DB PostgreSQL.
2.  Buat `Dockerfile` untuk aplikasi tersebut.
3.  Buat `docker-compose.yml` untuk menjalankan App + DB di laptop. Pastikan jalan lancar.

### Tahap 2: Version Control & CI
1.  Push kode ke GitHub.
2.  Buat GitHub Actions Workflow:
    *   Linting code (flake8).
    *   Unit Test.
    *   Build Docker Image.
    *   Push Image ke Docker Hub (tag: `latest` dan `sha-commit`).

### Tahap 3: Infrastructure (IaC)
1.  Gunakan **Terraform** untuk membuat:
    *   VPC & Security Group.
    *   K8s Cluster (EKS/GKE) atau simpelnya 1 EC2 instance yang sudah terinstall Microk8s/K3s.
    *   Database Managed Service (RDS) atau install DB di dalam cluster (StatefulSet).

### Tahap 4: Deployment (K8s)
1.  Buat K8s Manifests (`deployment.yaml`, `service.yaml`, `ingress.yaml`, `secret.yaml`).
2.  Gunakan **Helm** untuk membungkus manifest tersebut (Opsional, tapi nilai plus).
3.  Setup mekanisme deploy:
    *   *Cara Push*: Tambahkan step di GitHub Actions untuk `kubectl apply`.
    *   *Cara GitOps (Advanced)*: Setup **ArgoCD** di cluster, arahkan ke repo config.

### Tahap 5: Observability
1.  Install **Prometheus & Grafana** di cluster (pakai Helm Chart `kube-prometheus-stack`).
2.  Pastikan Anda bisa melihat grafik CPU/Memory dari Pod aplikasi Anda.
3.  (Bonus) Setup Alertmanager untuk kirim email jika Pod mati.

---

## Checklist Kelulusan
*   [ ] Kode ada di GitHub.
*   [ ] Ada badge "Passing" di tab Actions.
*   [ ] Docker Image tersedia di Docker Hub.
*   [ ] Infrastruktur bisa dibuat dengan 1 perintah `terraform apply`.
*   [ ] Aplikasi bisa diakses via Public IP / Domain.
*   [ ] Dashboard Grafana menampilkan metrik aplikasi.

## Tantangan Tambahan (Expert Mode)
1.  **HTTPS**: Pasang Cert-Manager untuk otomatisasi SSL Let's Encrypt.
2.  **Canary Deployment**: Rilis versi baru ke 10% user dulu sebelum ke semua.
3.  **Cost Optimization**: Gunakan Spot Instances di AWS untuk menghemat biaya server.

Semangat! Jika Anda bisa menyelesaikan proyek ini, Anda sudah **SIAP KERJA** sebagai DevOps Engineer.
