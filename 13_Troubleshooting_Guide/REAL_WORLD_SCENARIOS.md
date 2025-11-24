# Panduan Troubleshooting DevOps (Real World Scenarios)

Teori itu mudah, tapi saat production down jam 2 pagi, Anda butuh panduan praktis. Berikut adalah skenario masalah umum dan cara menanganinya.

## Skenario 1: "Server Lambat Banget!" (High Load)

**Gejala**: User komplain website loading lama.
**Langkah Investigasi**:

1.  **Masuk ke Server**: SSH ke server terkait.
2.  **Cek Load Average**:
    *   Command: `uptime` atau `top`.
    *   Analisis: Jika Load Average > Jumlah Core CPU, server overload.
3.  **Siapa Pelakunya?**:
    *   Command: `top` (Tekan `P` untuk sort CPU, `M` untuk sort RAM).
    *   *Kasus A*: Proses aplikasi (Java/Python/Node) makan CPU 100%. -> Kemungkinan bug di code (infinite loop) atau trafik tinggi.
    *   *Kasus B*: Database (MySQL/Postgres) makan CPU. -> Cek Slow Query.
    *   *Kasus C*: `kswapd0` tinggi. -> RAM habis, server sibuk swap ke disk.
4.  **Cek Disk I/O**:
    *   Command: `iotop`.
    *   Analisis: Apakah ada proses yang baca/tulis disk gila-gilaan?

**Solusi Cepat**:
*   Restart service yang bermasalah (`systemctl restart nginx`).
*   Jika trafik valid tinggi: Scale up (tambah CPU/RAM) atau Scale out (tambah server).

---

## Skenario 2: "Disk Penuh" (Disk Space Full)

**Gejala**: Aplikasi error "No space left on device", tidak bisa tulis log, database crash.
**Langkah Investigasi**:

1.  **Cek Partisi Mana yang Penuh**:
    *   Command: `df -h`.
    *   Lihat kolom `Use%`. Cari yang 100%.
2.  **Cari File Besar**:
    *   Masuk ke partisi penuh (misal `/var`).
    *   Command: `du -sh * | sort -rh | head -n 10`.
    *   Ini akan menampilkan 10 folder terbesar. Masuk ke folder itu, ulangi command sampai ketemu filenya.
3.  **Tersangka Umum**:
    *   File log lama (`/var/log/nginx/access.log` yang bergiga-giga).
    *   Docker overlay (`/var/lib/docker`).
    *   Artifact build lama.

**Solusi**:
*   Hapus log lama: `truncate -s 0 /var/log/nginx/access.log` (Jangan `rm` saat service jalan, nanti space gak balik).
*   Docker prune: `docker system prune -a` (Hati-hati, ini hapus semua container mati dan image tak terpakai).

---

## Skenario 3: "Koneksi Ditolak" (Connection Refused)

**Gejala**: `curl localhost:8080` error "Connection refused".
**Langkah Investigasi**:

1.  **Apakah Service Jalan?**:
    *   Command: `systemctl status nama-service`.
    *   Jika `inactive` atau `failed`, start service-nya.
2.  **Apakah Port Listen?**:
    *   Command: `netstat -tulpn | grep 8080` atau `ss -tulpn`.
    *   Jika kosong, berarti aplikasi jalan tapi tidak listen di port itu (salah config port?).
    *   Jika listen di `127.0.0.1:8080`, berarti hanya bisa diakses dari localhost. Jika mau diakses dari luar, harus `0.0.0.0:8080`.
3.  **Firewall?**:
    *   Jika dari localhost bisa tapi dari luar tidak bisa.
    *   Cek `sudo ufw status` atau Security Group di AWS.

---

## Skenario 4: "Deployment Gagal" (CI/CD Error)

**Gejala**: Pipeline merah di tahap Build atau Deploy.
**Langkah Investigasi**:

1.  **Baca Log!**: 90% jawaban ada di log console CI/CD. Scroll ke atas sampai ketemu error pertama.
2.  **Dependency Error**:
    *   "Module not found". -> Cek `package.json` atau `requirements.txt`. Apakah file itu ikut ke-commit?
3.  **Test Failed**:
    *   Unit test gagal. -> Salah coding.
4.  **Credential Error**:
    *   "Authentication failed". -> Cek Secrets di GitHub/GitLab. Apakah token expired?

---

## Skenario 5: "Container CrashLoopBackOff" (Kubernetes)

**Gejala**: Status pod `CrashLoopBackOff` (Mati, restart, mati lagi, restart lagi).
**Langkah Investigasi**:

1.  **Cek Log Pod**:
    *   `kubectl logs nama-pod --previous`.
    *   Lihat kenapa dia mati terakhir kali. Biasanya error code aplikasi.
2.  **Cek Events**:
    *   `kubectl describe pod nama-pod`.
    *   Lihat bagian bawah (Events). Apakah ada "OOMKilled" (Out of Memory)?
    *   Jika OOMKilled, berarti limit memory di YAML terlalu kecil. Naikkan limitnya.
3.  **Liveness Probe Gagal**:
    *   K8s membunuh pod karena health check gagal. Cek endpoint `/health` di aplikasi.

---

## Tips Mental Troubleshooting
1.  **Don't Panic**. Tarik napas.
2.  **Isolate the Problem**. Apakah di Network? Server? Database? Atau Code?
3.  **Check Changes**. "Apa yang berubah terakhir kali?" (Deploy baru? Config baru?). 80% insiden disebabkan oleh perubahan.
4.  **Google is your friend**. Copy paste error log ke Google.
