# Panduan Lengkap Monitoring & Logging (Prometheus & Grafana)

Tanpa monitoring, Anda "terbang buta". Anda tidak akan tahu server mati sampai user berteriak di media sosial.

## BAGIAN 1: Konsep Dasar

*   **Metrics (Angka)**: "CPU usage 90%", "Free RAM 200MB". Bagus untuk melihat tren dan kesehatan sistem. Tool: **Prometheus**.
*   **Logs (Teks)**: "Error: Connection refused at line 40". Bagus untuk investigasi penyebab masalah. Tool: **ELK Stack / Loki**.
*   **Alerting**: Memberitahu manusia saat ada yang salah (via Slack, Email, Telegram).

---

## BAGIAN 2: Prometheus (The Collector)

Prometheus bekerja dengan cara **Pull Model**. Dia "mendatangi" aplikasi Anda setiap beberapa detik dan bertanya "Bagaimana kabarmu?".

### 1. Arsitektur Sederhana
*   **Prometheus Server**: Menyimpan data time-series.
*   **Exporters**: Agen kecil yang dipasang di server target untuk menyediakan data.
    *   `node_exporter`: Untuk monitor OS (CPU, Disk, RAM).
    *   `mysqld_exporter`: Untuk monitor database MySQL.

### 2. Konfigurasi `prometheus.yml`
```yaml
global:
  scrape_interval: 15s # Ambil data tiap 15 detik

scrape_configs:
  - job_name: 'node_server'
    static_configs:
      - targets: ['localhost:9100'] # Alamat node_exporter
```

### 3. PromQL (Prometheus Query Language) Cheatsheet
Bahasa query untuk mengambil data dari Prometheus.

| Query | Arti |
| :--- | :--- |
| `up` | Apakah target hidup? (1=Yes, 0=No). |
| `node_cpu_seconds_total` | Total waktu CPU (raw counter). |
| `rate(node_cpu_seconds_total[5m])` | **PENTING!** Laju penggunaan CPU rata-rata 5 menit terakhir. |
| `node_filesystem_free_bytes` | Sisa disk space dalam bytes. |
| `http_requests_total{status="500"}` | Hitung total request yang error 500. |

---

## BAGIAN 3: Grafana (The Visualizer)

Grafana mengubah angka-angka membosankan dari Prometheus menjadi grafik yang indah.

### Langkah Setup Dashboard
1.  **Add Data Source**: Pilih Prometheus, masukkan URL (misal `http://localhost:9090`).
2.  **Create Dashboard**: Klik "+", lalu "Add Visualization".
3.  **Input Query**: Masukkan query PromQL (misal `100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)` untuk CPU Usage %).
4.  **Save**: Beri nama "Server Health".

---

## BAGIAN 4: Logging (ELK Stack vs Loki)

### ELK (Elasticsearch, Logstash, Kibana)
*   **Elasticsearch**: Database untuk simpan teks log.
*   **Logstash**: Pipa yang memproses log sebelum disimpan.
*   **Kibana**: UI untuk search log.
*   *Kekurangan*: Berat, butuh RAM besar (Java based).

### Loki (Grafana Loki)
*   Alternatif modern yang lebih ringan.
*   Dibuat oleh pembuat Grafana.
*   Hanya mengindeks metadata (label), bukan isi lognya -> Hemat storage.
*   Query language mirip PromQL (LogQL).

---

## 5. Latihan Praktis (Docker Compose)
Cara termudah belajar monitoring adalah menjalankannya di laptop.

File: `docker-compose.yml`
```yaml
version: '3'
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"

  node-exporter:
    image: prom/node-exporter
    ports:
      - "9100:9100"
```
1.  Jalankan `docker-compose up -d`.
2.  Buka Grafana di `localhost:3000` (user/pass: admin/admin).
3.  Tambahkan Prometheus (`http://prometheus:9090`) sebagai Data Source.
4.  Import Dashboard ID `1860` (Node Exporter Full) dari library Grafana.
5.  Boom! Anda punya monitoring server lengkap.
