# Panduan Lengkap Cloud Providers (AWS Basics)

Meskipun ada GCP dan Azure, AWS (Amazon Web Services) adalah pemimpin pasar. Konsepnya bisa ditransfer ke cloud lain.

## 1. Konsep Global Infrastructure
*   **Region**: Lokasi fisik data center (misal: `us-east-1` N. Virginia, `ap-southeast-1` Singapore). Pilih yang terdekat dengan user Anda untuk latency rendah.
*   **Availability Zone (AZ)**: Data center terpisah di dalam satu Region (misal: `ap-southeast-1a`, `ap-southeast-1b`). Jika satu gedung mati lampu, gedung sebelah (beda AZ) tetap nyala.

---

## 2. Layanan Inti AWS (The Big Three)

### A. EC2 (Elastic Compute Cloud) - "Sewa Komputer"
Ini adalah Virtual Machine (VPS).
*   **Instance Type**:
    *   `t2.micro` / `t3.micro`: Kecil, murah, cocok untuk belajar (Free Tier eligible).
    *   `m5.large`: General purpose.
    *   `c5.large`: Compute optimized (untuk proses berat).
*   **AMI (Amazon Machine Image)**: Template OS (Ubuntu, Amazon Linux, Windows).
*   **Key Pair**: File `.pem` untuk login SSH. Jangan sampai hilang!

### B. S3 (Simple Storage Service) - "Google Drive Unlimited"
Object storage untuk menyimpan file (gambar, video, backup, log).
*   **Bucket**: Wadah file (nama harus unik sedunia).
*   **Object**: Filenya itu sendiri.
*   **Storage Class**:
    *   `Standard`: Akses cepat, mahal.
    *   `Glacier`: Arsip jangka panjang, sangat murah, tapi butuh waktu jam-jaman untuk ambil data.

### C. IAM (Identity and Access Management) - "Satpam"
Mengatur siapa boleh melakukan apa.
*   **User**: Orang atau aplikasi.
*   **Group**: Kumpulan user (misal: Group `Admins`, Group `Developers`).
*   **Role**: Topi jabatan yang bisa dipinjam. Misal EC2 instance diberi Role "Boleh akses S3". Lebih aman daripada menyimpan username/password di dalam kodingan.
*   **Policy**: Dokumen JSON yang berisi aturan izin.

---

## 3. VPC (Virtual Private Cloud) - "Jaringan Kabel Virtual"
Anda membuat jaringan sendiri di awan.
*   **Subnet Public**: Punya akses langsung ke internet (untuk Web Server).
*   **Subnet Private**: Tidak ada akses langsung internet (untuk Database). Aman dari hacker.
*   **Internet Gateway (IGW)**: Pintu gerbang ke internet.
*   **NAT Gateway**: Mengizinkan server di private subnet untuk download update dari internet, tapi tidak bisa diakses DARI internet.

---

## 4. AWS CLI Cheatsheet
DevOps jarang klik-klik di console web, kita pakai CLI.

```bash
# Konfigurasi awal (masukkan Access Key & Secret Key)
aws configure

# List semua bucket S3
aws s3 ls

# Upload file ke S3
aws s3 cp my-file.txt s3://nama-bucket-saya/

# List server EC2 yang sedang running
aws ec2 describe-instances --filters "Name=instance-state-name,Values=running"

# Matikan server (Stop)
aws ec2 stop-instances --instance-ids i-1234567890abcdef0
```

## 5. Latihan Praktis (Free Tier)
1.  Daftar akun AWS (butuh kartu kredit/debit jenius/jago untuk verifikasi $1).
2.  Masuk ke Console, pilih region Singapore.
3.  Launch EC2 Instance (`t2.micro`, Ubuntu).
4.  SSH ke instance tersebut.
5.  Install Nginx.
6.  Buka Security Group port 80.
7.  Akses Public IP instance dari browser HP Anda.
