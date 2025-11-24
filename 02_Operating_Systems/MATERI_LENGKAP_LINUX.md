# Panduan Lengkap Sistem Operasi (Linux) untuk DevOps

Linux adalah "rumah" bagi DevOps. Hampir semua server di cloud berjalan di atas Linux.

## 1. Struktur File System Linux (Cheatsheet)

Di Windows kita punya C:\, D:\. Di Linux, semuanya berawal dari `/` (Root).

| Path | Deskripsi | Apa yang ada di sini? |
| :--- | :--- | :--- |
| `/` | **Root** | Awal dari segalanya. |
| `/bin` | **Binaries** | Program dasar user (`ls`, `cp`, `cat`). |
| `/sbin` | **System Binaries** | Program admin/root (`reboot`, `fdisk`, `iptables`). |
| `/etc` | **Etcetera (Config)** | **PENTING!** Semua file konfigurasi ada di sini (misal: `/etc/nginx/nginx.conf`). |
| `/var` | **Variable** | File yang sering berubah: **Log files** (`/var/log`), website (`/var/www`). |
| `/home` | **Home** | Folder user (misal: `/home/budi`). |
| `/root` | **Root Home** | Folder khusus user root (admin). |
| `/tmp` | **Temporary** | File sementara, dihapus saat restart. |
| `/proc` | **Process** | Info virtual tentang sistem (CPU, RAM) dalam bentuk file. |

---

## 2. Manajemen Permission (Hak Akses)

Linux sangat ketat soal siapa boleh buka file apa.
Gunakan `ls -l` untuk melihat permission.

Contoh output: `drwxr-xr--`

*   **d**: Directory (folder).
*   **rwx** (User/Owner): Read, Write, Execute.
*   **r-x** (Group): Read, Execute (No Write).
*   **r--** (Others): Read only.

### Command Penting
*   `chmod`: Ubah mode/permission.
    *   `chmod 777 file` (Bahaya! Semua orang bisa edit).
    *   `chmod 755 file` (Standard untuk script/program).
    *   `chmod 644 file` (Standard untuk file teks/config).
    *   `chmod +x script.sh` (Membuat file bisa dieksekusi).
*   `chown`: Ubah owner.
    *   `chown user:group file`.

---

## 3. Manajemen Proses

DevOps harus bisa menangani aplikasi yang hang atau memakan banyak resource.

### Cheatsheet Command Proses
| Command | Fungsi | Contoh |
| :--- | :--- | :--- |
| `ps aux` | Lihat semua proses yang berjalan | `ps aux \| grep nginx` |
| `top` / `htop` | Task manager real-time | Cek CPU/RAM usage. |
| `kill` | Menghentikan proses by PID | `kill 1234` |
| `kill -9` | Paksa bunuh proses (Force Kill) | `kill -9 1234` |
| `systemctl` | Mengelola service (Start/Stop) | `systemctl restart nginx` |

### Penjelasan `Load Average`
Saat ketik `top`, ada angka "Load Average: 0.50, 0.80, 1.00".
*   Angka 1: Rata-rata 1 menit terakhir.
*   Angka 2: Rata-rata 5 menit terakhir.
*   Angka 3: Rata-rata 15 menit terakhir.
*   **Arti**: Jika angka load > jumlah Core CPU, berarti sistem overload (antrian proses numpuk).

---

## 4. Networking Dasar di Linux

### Cek Koneksi & Port
*   `ping google.com`: Cek koneksi internet.
*   `curl -I google.com`: Cek header HTTP (lihat status 200 OK).
*   `netstat -tulpn` atau `ss -tulpn`: **Sangat Penting!** Melihat port mana yang sedang "Listen" (terbuka) dan program apa yang memakainya.
    *   Berguna saat debug: "Kenapa web server saya gak bisa diakses? Oh ternyata port 80 belum listen."

---

## 5. Latihan Praktis
1.  Buka terminal.
2.  Cek load average sistem Anda dengan `uptime` atau `top`.
3.  Buat file kosong `test.txt`.
4.  Ubah permissionnya agar hanya Anda yang bisa baca tulis (`chmod 600 test.txt`).
5.  Coba baca file itu (`cat test.txt`) -> Berhasil.
6.  Coba ubah permission jadi 000 (`chmod 000 test.txt`).
7.  Coba baca lagi -> Permission Denied.
