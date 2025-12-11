# 08. Monitoring & Logging

Setelah aplikasi berjalan di production, Anda perlu tahu apa yang terjadi. Monitoring memberitahu *kapan* ada masalah, Logging memberitahu *mengapa* ada masalah.

## Monitoring (Metrics)
Mengumpulkan data numerik dari waktu ke waktu (CPU usage, Memory usage, Request count, Latency).

1.  **Prometheus**
    *   Time-series database.
    *   Pull-based model.
    *   Query language: PromQL.
2.  **Grafana**
    *   Visualisasi data (Dashboard).
    *   Bisa mengambil data dari Prometheus, MySQL, CloudWatch, dll.
3.  **Nagios / Zabbix** (Traditional monitoring).

## Logging
Mengumpulkan output teks dari aplikasi/sistem.

1.  **ELK Stack (Elasticsearch, Logstash, Kibana)**
    *   Elasticsearch: Search engine & database log.
    *   Logstash: Log collector & processor.
    *   Kibana: Visualisasi log.
2.  **EFK Stack (Elasticsearch, Fluentd, Kibana)**
    *   Fluentd lebih ringan daripada Logstash.
3.  **Loki (by Grafana)**
    *   Log aggregation system yang didesain seperti Prometheus.

## Tracing (Observability)
Melacak perjalanan request antar microservices.
*   **Jaeger**, **Zipkin**.

## Latihan Praktis
1.  Setup Prometheus dan Grafana menggunakan Docker Compose.
2.  Buat dashboard Grafana untuk memonitor penggunaan resource host (menggunakan `node_exporter`).
3.  Kirim log aplikasi ke file, lalu gunakan Fluentd/Logstash untuk mengirimnya ke Elasticsearch (atau sekadar output ke stdout untuk Docker logging).

## Referensi Belajar
*   [Prometheus Documentation](https://prometheus.io/docs/introduction/overview/)
*   [Grafana Documentation](https://grafana.com/docs/)
*   [Elastic Stack Documentation](https://www.elastic.co/guide/index.html)
