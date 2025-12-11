# Panduan Lengkap Python untuk DevOps

Python adalah bahasa yang paling populer untuk scripting dan otomatisasi di dunia DevOps karena mudah dibaca dan memiliki library yang sangat luas.

## 1. Dasar-Dasar Python (Cheatsheet)

### Variabel & Tipe Data
```python
# String
server_name = "web-server-01"
# Integer
port = 8080
# Float
cpu_usage = 15.5
# Boolean
is_active = True
# List (Array)
servers = ["web01", "web02", "db01"]
# Dictionary (Key-Value)
config = {
    "host": "localhost",
    "port": 3306,
    "user": "admin"
}
```

### Control Flow
```python
# If-Else
usage = 85
if usage > 90:
    print("Critical: High CPU usage!")
elif usage > 70:
    print("Warning: Moderate CPU usage.")
else:
    print("Normal.")

# Loops
servers = ["server1", "server2", "server3"]
for server in servers:
    print(f"Checking {server}...")
```

### Functions
```python
def check_status(service_name):
    # Simulasi cek status
    return f"{service_name} is running"

print(check_status("nginx"))
```

---

## 2. Studi Kasus DevOps: Monitoring Disk Space

Berikut adalah contoh script Python untuk mengecek penggunaan disk dan mengirim peringatan jika penuh.

### Script: `monitor_disk.py`

```python
import shutil
import smtplib
from email.mime.text import MIMEText

# Konfigurasi
THRESHOLD = 80  # Persen
PATH = "/"      # Root partition

def check_disk_usage(path):
    """Mengembalikan persentase penggunaan disk."""
    total, used, free = shutil.disk_usage(path)
    percent_used = (used / total) * 100
    return percent_used

def send_alert(usage):
    """Simulasi kirim email alert."""
    msg = f"WARNING: Disk usage is at {usage:.2f}%!"
    print(f"[EMAIL SENT] {msg}") 
    # Di dunia nyata, gunakan smtplib untuk kirim email beneran

def main():
    usage = check_disk_usage(PATH)
    print(f"Current Disk Usage: {usage:.2f}%")
    
    if usage > THRESHOLD:
        send_alert(usage)
    else:
        print("Disk space is safe.")

if __name__ == "__main__":
    main()
```

### Penjelasan Code
1.  **`shutil`**: Library bawaan Python untuk operasi file tingkat tinggi, termasuk cek disk usage.
2.  **Fungsi `check_disk_usage`**: Menghitung persentase penggunaan.
3.  **Logika `main`**: Membandingkan penggunaan saat ini dengan `THRESHOLD`.

---

## 3. Studi Kasus DevOps: Parsing Log File

Seringkali kita perlu membaca log error dari web server.

### Script: `log_parser.py`

```python
# Contoh baris log: "2023-10-01 12:00:01 ERROR Connection timeout"

def parse_logs(file_path):
    error_count = 0
    with open(file_path, 'r') as file:
        for line in file:
            if "ERROR" in line:
                error_count += 1
                print(f"Found error: {line.strip()}")
    
    return error_count

# Cara pakai (pastikan ada file app.log)
# total_errors = parse_logs("app.log")
# print(f"Total Errors: {total_errors}")
```

---

## 4. Library Python Wajib untuk DevOps

| Library | Kegunaan | Contoh Use Case |
| :--- | :--- | :--- |
| **`os` / `subprocess`** | Interaksi dengan OS | Menjalankan command bash dari Python (`ls`, `mkdir`). |
| **`sys`** | System parameters | Mengambil argumen dari command line (`python script.py arg1`). |
| **`requests`** | HTTP Library | Cek status website, panggil REST API. |
| **`boto3`** | AWS SDK | Membuat EC2, upload file ke S3 secara otomatis. |
| **`paramiko`** | SSH Client | Remote ke server lain lewat SSH dan jalankan perintah. |
| **`pandas`** | Data Analysis | Analisis data log yang sangat besar (CSV/Excel). |

## 5. Latihan Mandiri
1.  Install library `requests` (`pip install requests`).
2.  Buat script untuk mengecek status code website google.com. Jika bukan 200, print "Website Down".
