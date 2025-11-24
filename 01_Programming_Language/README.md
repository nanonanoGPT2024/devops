# 01. Bahasa Pemrograman (Programming Language)

Sebagai seorang DevOps Engineer, Anda perlu menguasai setidaknya satu bahasa pemrograman untuk keperluan scripting, otomatisasi, dan memahami kode aplikasi yang akan Anda deploy.

## Pilihan Bahasa Utama
1.  **Python** (Sangat Direkomendasikan)
    *   Mudah dipelajari.
    *   Banyak library untuk otomatisasi (Boto3 untuk AWS, Fabric, dll).
    *   Digunakan secara luas di industri AI/ML dan Data.
2.  **Go (Golang)**
    *   Bahasa di balik banyak tool DevOps modern (Docker, Kubernetes, Terraform).
    *   Performa tinggi dan concurrency yang baik.
    *   Menghasilkan binary static yang mudah didistribusikan.
3.  **Node.js / JavaScript**
    *   Penting jika Anda banyak bekerja dengan aplikasi web modern.
4.  **Rust** (Opsional/Advanced)
    *   Mulai populer untuk tool CLI yang cepat dan aman.

## Materi Pembelajaran
*   **Sintaks Dasar**: Variabel, Tipe Data, Loop, Kondisional.
*   **Struktur Data**: List, Dictionary/Map, Set.
*   **Fungsi & Modul**: Cara mengorganisir kode.
*   **File I/O**: Membaca dan menulis file (penting untuk parsing log atau config).
*   **Networking**: Membuat HTTP request, socket programming sederhana.
*   **Interaksi OS**: Menjalankan command system dari kode (misal `subprocess` di Python).

## Latihan Praktis
1.  Buat script untuk memonitor penggunaan disk space dan kirim alert jika > 90%.
2.  Buat script untuk mem-parsing file log Apache/Nginx dan hitung jumlah error 500.
3.  Buat REST API sederhana yang mengembalikan info sistem (hostname, IP, uptime).

## Referensi Belajar
*   [Python.org Documentation](https://docs.python.org/3/)
*   [Learn Go with Tests](https://quii.gitbook.io/learn-go-with-tests/)
*   [FreeCodeCamp](https://www.freecodecamp.org/)
