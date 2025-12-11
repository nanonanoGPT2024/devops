# Panduan Lengkap Terminal & Bash Scripting

Bash Scripting adalah seni menyatukan command-command Linux menjadi program otomatisasi.

## 1. Bash Cheatsheet (Command Sehari-hari)

### Navigasi & File
| Command | Deskripsi |
| :--- | :--- |
| `pwd` | Print Working Directory (Saya ada di mana?). |
| `cd -` | Kembali ke direktori sebelumnya. |
| `ls -lah` | List file lengkap (hidden, size readable, permission). |
| `cp -r source dest` | Copy folder (recursive). |
| `mv old new` | Rename atau memindahkan file. |
| `rm -rf folder` | **Hati-hati!** Hapus folder dan isinya secara paksa. |
| `mkdir -p a/b/c` | Buat folder bersarang sekaligus. |

### Pencarian & Filter (The Power of Pipe `|`)
*   `grep`: Mencari teks dalam file/output.
    *   `cat app.log | grep "ERROR"`
*   `find`: Mencari file.
    *   `find /var/log -name "*.log"` (Cari semua file .log di /var/log).
*   `head` / `tail`: Baca awal/akhir file.
    *   `tail -f app.log` (Monitor log secara realtime/live).

---

## 2. Dasar Bash Scripting

Buat file dengan akhiran `.sh`, misal `backup.sh`.
Baris pertama wajib: `#!/bin/bash` (Shebang).

### Variabel & Input
```bash
#!/bin/bash

# Definisi Variabel
NAMA="DevOps Engineer"
TANGGAL=$(date +%Y-%m-%d) # Eksekusi command date dan simpan hasilnya

echo "Halo $NAMA, hari ini tanggal $TANGGAL"

# Input User
echo "Siapa nama server ini?"
read SERVER_NAME
echo "Mengkonfigurasi $SERVER_NAME..."
```

### Kondisional (If-Else)
```bash
#!/bin/bash

DISK_USAGE=$(df -h / | grep / | awk '{ print $5 }' | sed 's/%//g')

if [ "$DISK_USAGE" -gt 90 ]; then
    echo "BAHAYA: Disk hampir penuh ($DISK_USAGE%)"
else
    echo "Aman: Disk usage $DISK_USAGE%"
fi
```

### Loops (Perulangan)
```bash
# Loop list file
for file in *.txt; do
    echo "Memproses file: $file"
    mv "$file" "$file.bak"
done

# Loop angka
for i in {1..5}; do
    echo "Percobaan ke-$i"
    sleep 1 # Jeda 1 detik
done
```

---

## 3. Studi Kasus: Script Backup Otomatis

Ini adalah script yang sering dipakai di dunia nyata untuk backup folder website/database.

### Script: `auto_backup.sh`

```bash
#!/bin/bash

# Konfigurasi
SOURCE_DIR="/var/www/html"
BACKUP_DIR="/backup"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="backup_web_$DATE.tar.gz"

# 1. Pastikan folder backup ada
mkdir -p $BACKUP_DIR

# 2. Lakukan kompresi
echo "Memulai backup dari $SOURCE_DIR ke $BACKUP_DIR/$FILENAME..."
tar -czf "$BACKUP_DIR/$FILENAME" "$SOURCE_DIR"

# 3. Cek status
if [ $? -eq 0 ]; then
    echo "Backup BERHASIL!"
else
    echo "Backup GAGAL!"
    exit 1
fi

# 4. Hapus backup yang lebih tua dari 7 hari (Housekeeping)
find $BACKUP_DIR -type f -name "*.tar.gz" -mtime +7 -delete
echo "Backup lama telah dibersihkan."
```

### Penjelasan Script
1.  **`tar -czf`**: Membuat arsip `.tar.gz` (Compressed).
2.  **`$?`**: Variabel spesial yang menyimpan status exit command terakhir. `0` artinya sukses, selain 0 artinya error.
3.  **`find ... -mtime +7 -delete`**: Mencari file yang dimodifikasi lebih dari 7 hari lalu dan menghapusnya. Ini penting agar disk tidak penuh.

---

## 4. Tips Produktivitas Terminal
1.  **Tab Completion**: Selalu tekan `Tab` untuk melengkapi nama file/command. Jangan ketik manual!
2.  **History**: Tekan `Panah Atas` untuk melihat command sebelumnya.
3.  **Ctrl+R**: Cari history command. Tekan Ctrl+R lalu ketik "docker", dia akan mencari command docker terakhir yang Anda ketik.
4.  **Alias**: Buat singkatan command panjang.
    *   Edit `~/.bashrc`, tambah: `alias ll='ls -lah'`
    *   Sekarang ketik `ll` saja sudah cukup.

## 5. Latihan Mandiri
1.  Buat script `hello.sh` yang menyapa user saat ini (gunakan variabel environment `$USER`).
2.  Buat script yang mengecek apakah folder `backup` ada. Jika tidak ada, buat foldernya.
