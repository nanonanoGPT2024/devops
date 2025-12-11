# 05. Web Servers

Web server adalah software yang melayani konten website kepada pengguna. Sebagai DevOps, Anda harus bisa menginstal, mengkonfigurasi, dan mengamankan web server.

## Web Server Populer
1.  **Nginx**
    *   Sangat populer sebagai web server dan Reverse Proxy.
    *   Ringan dan performa tinggi (event-driven).
2.  **Apache HTTP Server**
    *   Pemain lama, sangat stabil, menggunakan model process/thread.
    *   Konfigurasi menggunakan `.htaccess`.
3.  **IIS (Internet Information Services)**
    *   Web server default untuk lingkungan Windows Server.
4.  **Caddy**
    *   Modern, otomatisasi HTTPS (Let's Encrypt) secara default.

## Konsep Penting
1.  **Virtual Hosts / Server Blocks**: Menjalankan beberapa website di satu server.
2.  **Reverse Proxy**: Meneruskan request ke aplikasi backend (misal Node.js atau Python app).
3.  **Load Balancing**: Membagi trafik ke beberapa backend server.
4.  **Caching**: Menyimpan konten statis untuk mempercepat akses.
5.  **SSL/TLS Termination**: Menangani enkripsi/dekripsi di level web server.

## Latihan Praktis
1.  Install Nginx.
2.  Konfigurasi Nginx sebagai Reverse Proxy untuk aplikasi "Hello World" (bisa pakai Python/Node.js).
3.  Setup Load Balancer sederhana dengan Nginx yang membagi trafik ke 2 instance aplikasi.
4.  Amankan web server dengan mematikan versi server di header response.

## Referensi Belajar
*   [Nginx Official Documentation](https://nginx.org/en/docs/)
*   [Apache HTTP Server Documentation](https://httpd.apache.org/docs/)
