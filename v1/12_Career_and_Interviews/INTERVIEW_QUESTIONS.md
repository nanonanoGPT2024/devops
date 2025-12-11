# Pertanyaan Interview DevOps & Jawabannya

Berikut adalah kumpulan pertanyaan yang sering muncul saat interview posisi DevOps Engineer, mulai dari level Junior hingga Senior.

## 1. General & Culture

**Q: Apa itu DevOps menurut Anda?**
*   *Jawaban*: DevOps bukan sekadar tools, tapi budaya kolaborasi antara tim Development (pengembang) dan Operations (infrastruktur) untuk mempercepat pengiriman software dengan kualitas tinggi melalui otomatisasi.

**Q: Jelaskan konsep "Shift Left".**
*   *Jawaban*: Memindahkan proses testing dan security lebih awal dalam siklus pengembangan (ke kiri timeline). Tujuannya menemukan bug/celah keamanan sejak dini, bukan saat mau rilis.

---

## 2. Linux & OS

**Q: Bagaimana cara mengecek proses yang memakan memori paling besar di Linux?**
*   *Jawaban*: Gunakan command `top` atau `htop`, lalu sort by Memory (tekan `M` di top). Atau gunakan `ps aux --sort=-%mem | head`.

**Q: Apa itu "Zombie Process"?**
*   *Jawaban*: Proses yang sudah selesai eksekusi tapi masih ada entry-nya di process table karena parent process-nya belum membaca exit statusnya.

**Q: Apa bedanya Hard Link dan Soft Link?**
*   *Jawaban*:
    *   *Soft Link (Symlink)*: Seperti shortcut di Windows. Jika file asli dihapus, link rusak.
    *   *Hard Link*: Menunjuk ke inode yang sama di disk. Jika file asli dihapus, data tetap ada selama masih ada hard link lain yang menunjuk ke situ.

---

## 3. Networking

**Q: Apa yang terjadi saat Anda mengetik google.com di browser?**
*   *Jawaban*:
    1.  Browser cek cache DNS lokal.
    2.  Jika tidak ada, tanya ke DNS Resolver -> Root Server -> TLD Server (.com) -> Authoritative Server (google.com).
    3.  Dapat IP Address.
    4.  Browser inisiasi TCP Handshake (SYN, SYN-ACK, ACK) ke IP tersebut.
    5.  Jika HTTPS, lakukan TLS Handshake.
    6.  Kirim HTTP GET Request.
    7.  Server balas dengan HTML.

**Q: Apa bedanya TCP dan UDP?**
*   *Jawaban*:
    *   *TCP*: Reliable, connection-oriented, urutan paket terjamin (contoh: Web, Email).
    *   *UDP*: Cepat, connectionless, paket bisa hilang/acak (contoh: Video Streaming, Gaming, DNS).

---

## 4. Container & Orchestration (Docker/K8s)

**Q: Apa bedanya Virtual Machine (VM) dan Container?**
*   *Jawaban*: VM memvirtualisasi hardware (punya OS sendiri, berat). Container memvirtualisasi OS (berbagi kernel host, ringan).

**Q: Di Kubernetes, apa itu Pod?**
*   *Jawaban*: Unit terkecil yang bisa dideploy di K8s. Satu pod bisa berisi satu atau lebih container yang berbagi network dan storage.

**Q: Bagaimana cara mengekspos aplikasi di K8s ke internet?**
*   *Jawaban*: Menggunakan Service tipe `LoadBalancer` atau menggunakan `Ingress` Controller.

---

## 5. CI/CD

**Q: Jelaskan perbedaan Continuous Delivery dan Continuous Deployment.**
*   *Jawaban*:
    *   *Delivery*: Kode otomatis di-build dan di-test, siap rilis ke production, tapi deployment dilakukan **manual** (klik tombol).
    *   *Deployment*: Semuanya otomatis sampai ke production tanpa intervensi manusia (kecuali test gagal).

**Q: Jika build gagal di pipeline, apa yang Anda lakukan?**
*   *Jawaban*: Cek log error di CI server, reproduksi error di lokal, perbaiki kode/config, lalu push ulang. Jangan biarkan pipeline merah terlalu lama.

---

## 6. Cloud (AWS)

**Q: Apa bedanya S3 dan EBS?**
*   *Jawaban*:
    *   *S3 (Simple Storage Service)*: Object storage. Bisa diakses via HTTP dari mana saja. Untuk simpan file statis, backup.
    *   *EBS (Elastic Block Store)*: Block storage. Seperti harddisk yang dicolok ke EC2. Hanya bisa diakses oleh satu instance (kecuali Multi-Attach).

**Q: Bagaimana cara mengamankan akses ke server EC2?**
*   *Jawaban*: Gunakan Security Group (hanya buka port yang perlu), letakkan di Private Subnet, gunakan Bastion Host/VPN, dan disable password auth (pakai SSH Key).

---

## 7. Terraform (IaC)

**Q: Apa fungsi `terraform.tfstate`?**
*   *Jawaban*: File database yang mencatat kondisi infrastruktur yang sebenarnya (mapping antara resource di kode dengan resource asli di cloud).

**Q: Apa yang terjadi jika Anda menghapus resource manual di console AWS, lalu menjalankan `terraform apply`?**
*   *Jawaban*: Terraform akan mendeteksi bahwa resource hilang (drift) dan akan mencoba membuatnya kembali agar sesuai dengan kode.

---

## 8. Skenario Masalah (Troubleshooting)

**Q: Website lambat diakses, apa langkah debugging Anda?**
*   *Jawaban*:
    1.  Cek monitoring (CPU/RAM server penuh?).
    2.  Cek log web server (Nginx/Apache) & aplikasi.
    3.  Cek database (Slow query? Connection pool habis?).
    4.  Cek network (Latency tinggi? Packet loss?).

**Q: Developer bilang "Di laptop saya jalan, di server error". Apa solusinya?**
*   *Jawaban*: Itulah kenapa kita pakai Docker. Pastikan environment dev dan prod identik menggunakan container. Cek juga perbedaan Environment Variables.
