# Panduan Lengkap Design Patterns & Best Practices

Menjadi DevOps bukan cuma soal tools, tapi pola pikir (mindset) bagaimana membangun sistem yang **Resilient** (tahan banting) dan **Scalable** (bisa membesar).

## 1. Microservices Architecture

### Monolith vs Microservices
*   **Monolith**: Satu aplikasi besar. Semua fitur (User, Produk, Order) jadi satu code base.
    *   *Pro*: Mudah dideploy di awal.
    *   *Con*: Satu error kecil bisa mematikan semua fitur. Susah di-scale per fitur.
*   **Microservices**: Memecah aplikasi jadi service kecil-kecil yang saling ngobrol via API.
    *   *Pro*: Jika fitur "Produk" error, fitur "User" tetap jalan. Bisa scale independen.
    *   *Con*: Kompleksitas tinggi (monitoring susah, tracing susah).

### Pola Komunikasi
*   **Synchronous (REST/gRPC)**: Telponan. "Halo, minta data user dong" -> "Tunggu bentar... ini datanya". (Blocking).
*   **Asynchronous (Message Queue - RabbitMQ/Kafka)**: Kirim surat/WA. "Tolong proses order ini ya, kabari kalau sudah". (Non-blocking).

---

## 2. The Twelve-Factor App (Kitab Suci SaaS)
12 prinsip untuk membuat aplikasi modern (Cloud Native). Berikut yang paling krusial bagi DevOps:

1.  **Codebase**: Satu repo untuk satu aplikasi, banyak deploy (dev, staging, prod).
2.  **Dependencies**: Jangan mengandalkan library sistem. Deklarasikan semua di `package.json` atau `requirements.txt`.
3.  **Config**: **JANGAN HARDCODE PASSWORD DI CODE!** Simpan config di Environment Variables (`.env`).
4.  **Backing Services**: Perlakukan database, cache, queue sebagai "sumber daya terlampir" yang bisa diganti-ganti URL-nya via config.
5.  **Build, Release, Run**: Pisahkan tahap build (compile) dan run. Jangan edit code langsung di server production!
6.  **Disposability**: Aplikasi harus bisa start cepat dan mati dengan anggun (graceful shutdown). Container itu fana (mudah mati/diganti).
7.  **Dev/Prod Parity**: Usahakan lingkungan development semirip mungkin dengan production (gunakan Docker!).
8.  **Logs**: Perlakukan log sebagai event stream (output ke `stdout`), jangan urus file log di dalam aplikasi. Biarkan tool lain (Fluentd) yang mengurus filenya.

---

## 3. GitOps (Modern Deployment)

Prinsip: **Git adalah satu-satunya sumber kebenaran (Single Source of Truth).**

*   **Cara Lama**: SSH ke server, `git pull`, restart service. (Rawan lupa, rawan beda config antar server).
*   **Cara GitOps**:
    1.  Anda update file config Kubernetes (YAML) di Git repo.
    2.  Ada agen (misal **ArgoCD**) di dalam cluster Kubernetes yang memantau Git.
    3.  ArgoCD melihat "Oh, di Git imagenya versi v2, tapi di cluster masih v1".
    4.  ArgoCD otomatis melakukan sync/deploy untuk menyamakan kondisi cluster dengan Git.

---

## 4. High Availability (HA) & Scalability

### Scaling
*   **Vertical Scaling (Scale Up)**: Beli server yang lebih mahal (RAM gede, CPU kenceng). Ada batas mentoknya.
*   **Horizontal Scaling (Scale Out)**: Tambah jumlah server murah jadi banyak. (1 server -> 10 server). Ini cara cloud.

### Load Balancing
Membagi trafik ke banyak server.
*   **Health Check**: Load balancer harus rajin ngecek, "Server 1 sehat? Server 2 sehat?". Jika Server 2 mati, stop kirim trafik ke sana.

### Self-Healing
Sistem yang bisa menyembuhkan diri sendiri.
*   Contoh: Kubernetes Auto-restart. Jika aplikasi crash, Kubernetes otomatis restart pod-nya.
*   Contoh: AWS Auto Scaling Group. Jika CPU rata-rata > 80%, otomatis tambah 1 server baru.

## 5. Latihan Konsep
1.  Buka aplikasi yang sedang Anda kembangkan.
2.  Cek apakah ada config (DB password, API Key) yang di-hardcode? Pindahkan ke Environment Variable.
3.  Bayangkan jika server mati mendadak (cabut kabel), apakah data hilang? Jika ya, berarti aplikasi Anda belum *Stateless*.
