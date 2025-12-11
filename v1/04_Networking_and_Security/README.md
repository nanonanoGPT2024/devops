# 04. Networking & Security

Memahami bagaimana komputer berkomunikasi satu sama lain adalah krusial untuk troubleshooting dan mendesain infrastruktur yang aman.

## Konsep Networking
1.  **OSI Model**: Pahami 7 layer, terutama Layer 3 (Network), Layer 4 (Transport), dan Layer 7 (Application).
2.  **TCP/IP**: IP Address (v4 vs v6), Subnetting, CIDR, Gateway.
3.  **Protocols**:
    *   **TCP vs UDP**: Kapan menggunakan yang mana?
    *   **DNS**: Bagaimana domain name diterjemahkan ke IP. Record types (A, CNAME, MX, TXT).
    *   **HTTP/HTTPS**: Methods (GET, POST), Status Codes (2xx, 3xx, 4xx, 5xx), Headers, Cookies.
    *   **SSH**: Secure Shell untuk remote access.
    *   **FTP/SFTP**: File transfer.
    *   **SSL/TLS**: Enkripsi data in-transit. Handshake process.

## Konsep Security
1.  **Firewalls**: Iptables, UFW, Security Groups (di Cloud).
2.  **Proxy**: Forward Proxy vs Reverse Proxy.
3.  **Load Balancers**: L4 vs L7 Load Balancing.
4.  **VPN**: Virtual Private Network.
5.  **Authentication & Authorization**: Basic Auth, OAuth, JWT.

## Latihan Praktis
1.  Gunakan `dig` atau `nslookup` untuk men-trace DNS resolution dari sebuah website.
2.  Analisis traffic network menggunakan Wireshark atau `tcpdump`.
3.  Setup firewall sederhana menggunakan UFW di Linux untuk memblokir semua port kecuali 22 (SSH) dan 80 (HTTP).
4.  Setup HTTPS di web server lokal menggunakan Self-Signed Certificate.

## Referensi Belajar
*   [Computer Networking: A Top-Down Approach](https://gaia.cs.umass.edu/kurose_ross/index.php)
*   [MDN Web Docs - HTTP](https://developer.mozilla.org/en-US/docs/Web/HTTP)
*   [Cloudflare Learning Center](https://www.cloudflare.com/learning/)
