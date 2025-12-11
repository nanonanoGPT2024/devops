# Panduan Lengkap Web Server (Nginx)

Nginx (dibaca "Engine X") adalah web server yang sangat cepat dan ringan. Di dunia DevOps, Nginx sering digunakan sebagai **Reverse Proxy** dan **Load Balancer**.

## 1. Konsep Dasar

*   **Web Server**: Melayani file statis (HTML, CSS, JS, Gambar).
*   **Reverse Proxy**: Perantara. User akses Nginx -> Nginx meneruskan ke Aplikasi (Node.js/Python/Go) -> Aplikasi balas ke Nginx -> Nginx balas ke User.
    *   *Kenapa butuh ini?* Keamanan, SSL termination, Caching, dan Load Balancing.

## 2. Instalasi & Perintah Dasar
```bash
# Install (Ubuntu/Debian)
sudo apt update
sudo apt install nginx

# Cek Status
systemctl status nginx

# Test Config (PENTING sebelum restart!)
sudo nginx -t

# Reload Config (Tanpa downtime)
sudo systemctl reload nginx
```

## 3. Struktur Konfigurasi Nginx
File konfigurasi utama biasanya di `/etc/nginx/nginx.conf`.
Namun, best practice-nya adalah membuat file config per website di `/etc/nginx/sites-available/` dan di-link ke `/etc/nginx/sites-enabled/`.

### Contoh Config: Reverse Proxy (Paling Sering Dipakai)
Skenario: Anda punya aplikasi Node.js berjalan di port 3000. Anda ingin user mengaksesnya lewat domain `api.example.com` di port 80.

File: `/etc/nginx/sites-available/api.example.com`

```nginx
server {
    listen 80;
    server_name api.example.com;

    location / {
        # Teruskan request ke aplikasi backend
        proxy_pass http://localhost:3000;
        
        # Header standar untuk diteruskan ke backend
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Contoh Config: Load Balancer
Skenario: Anda punya 3 server backend (app1, app2, app3). Nginx akan membagi beban trafik ke mereka.

```nginx
upstream backend_servers {
    # Daftar server backend
    server localhost:3001;
    server localhost:3002;
    server localhost:3003;
}

server {
    listen 80;
    server_name loadbalance.example.com;

    location / {
        proxy_pass http://backend_servers;
    }
}
```

## 4. Keamanan Nginx (Hardening)
Tambahkan ini di blok `server` atau `http` untuk meningkatkan keamanan.

```nginx
# Sembunyikan versi Nginx (biar hacker gak tau versi berapa)
server_tokens off;

# Mencegah Clickjacking (X-Frame-Options)
add_header X-Frame-Options "SAMEORIGIN";

# Mencegah XSS (Cross-Site Scripting)
add_header X-XSS-Protection "1; mode=block";
```

## 5. Latihan Praktis
1.  Install Nginx di laptop/VM Anda.
2.  Jalankan aplikasi web sederhana di port 8080 (bisa pakai `python3 -m http.server 8080`).
3.  Konfigurasi Nginx agar saat Anda buka `localhost` (port 80), dia menampilkan isi dari aplikasi port 8080 tersebut.
