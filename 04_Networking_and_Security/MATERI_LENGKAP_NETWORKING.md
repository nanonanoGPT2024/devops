# Panduan Lengkap Networking & Security untuk DevOps

Networking adalah "pipa" yang menghubungkan semua server dan user. Jika pipa bocor atau mampet, aplikasi mati.

## 1. Konsep Dasar Networking (The Essentials)

### IP Address & Subnetting (Sederhana)
*   **IP Public**: Alamat rumah yang bisa dilihat semua orang di internet (misal: 8.8.8.8).
*   **IP Private**: Alamat dalam jaringan lokal (LAN/VPC), tidak bisa diakses langsung dari internet.
    *   Class A: `10.0.0.0` - `10.255.255.255` (Biasa dipakai di AWS/GCP VPC).
    *   Class C: `192.168.0.0` - `192.168.255.255` (Biasa di WiFi rumah).
*   **CIDR**: Cara menulis range IP.
    *   `/32`: 1 IP (Spesifik).
    *   `/24`: 256 IP (Standar subnet).
    *   `/0`: `0.0.0.0/0` (Semua IP / Internet).

### Ports (Pintu Masuk)
Server itu seperti rumah, Port adalah pintunya.
| Port | Service | Kegunaan |
| :--- | :--- | :--- |
| **22** | SSH | Remote access server (Secure). |
| **80** | HTTP | Web traffic (Tidak terenkripsi). |
| **443** | HTTPS | Web traffic aman (SSL/TLS). |
| **53** | DNS | Domain Name System. |
| **3306** | MySQL | Database MySQL. |
| **5432** | PostgreSQL | Database PostgreSQL. |
| **6379** | Redis | Caching. |

---

## 2. Tools Networking Wajib (Cheatsheet)

### `curl` (Client URL)
Pisau lipat Swiss Army untuk HTTP request.
*   `curl https://google.com`: Download source code HTML.
*   `curl -I https://google.com`: Cek header (Lihat server type, cache, status code).
*   `curl -v https://google.com`: Verbose (Lihat proses handshake, request, dan response detail).
*   `curl -X POST -d "data=123" https://api.com`: Kirim data POST (Testing API).

### `ssh` (Secure Shell)
*   Login: `ssh user@192.168.1.5`
*   Login pakai key: `ssh -i my-key.pem user@192.168.1.5`
*   Port forwarding (Tunneling): `ssh -L 8080:localhost:80 user@server` (Akses web server lokal di remote server lewat laptop kita).

### `nc` (Netcat)
Untuk debugging koneksi raw.
*   `nc -zv google.com 443`: Cek apakah port 443 di google.com terbuka (Zero-I/O mode, Verbose).
*   Sangat berguna untuk cek firewall: "Apakah server App bisa connect ke server DB di port 3306?" -> `nc -zv db-server 3306`.

---

## 3. Keamanan (Security) Dasar

### Firewall (UFW / Security Groups)
Prinsip utama: **Block All, Allow Necessary**.
Jangan buka semua port (`0.0.0.0/0` allow all) kecuali terpaksa.

Contoh setting UFW (Uncomplicated Firewall) di Ubuntu:
```bash
sudo ufw default deny incoming  # Tolak semua tamu
sudo ufw default allow outgoing # Boleh keluar
sudo ufw allow 22/tcp           # Buka pintu SSH
sudo ufw allow 80/tcp           # Buka pintu Web
sudo ufw allow 443/tcp          # Buka pintu HTTPS
sudo ufw enable                 # Nyalakan satpam
```

### SSH Hardening (Wajib di Server Production)
Edit file `/etc/ssh/sshd_config`:
1.  **Disable Root Login**: `PermitRootLogin no` (Login pakai user biasa, lalu `sudo`).
2.  **Disable Password Auth**: `PasswordAuthentication no` (Wajib pakai SSH Key, anti brute-force).
3.  **Change Port** (Opsional): Ganti port 22 ke port acak (misal 2222) untuk menghindari bot scanner.

### SSL/TLS (HTTPS)
Jangan pernah deploy web login tanpa HTTPS. Data password akan dikirim plain text dan bisa dibaca hacker di WiFi yang sama.
Gunakan **Let's Encrypt** (Certbot) untuk SSL gratis seumur hidup.

---

## 4. Latihan Praktis
1.  Gunakan `curl -v` ke sebuah website (misal `github.com`). Perhatikan bagian `TLS handshake`.
2.  Cek IP public internet Anda: `curl ifconfig.me`.
3.  Di Windows/Linux, coba `ping 8.8.8.8`.
4.  Gunakan `nslookup google.com` untuk melihat IP address di balik domain google.
