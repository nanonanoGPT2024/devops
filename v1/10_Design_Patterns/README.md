# 10. Design Patterns & Best Practices

DevOps bukan hanya tentang tools, tapi juga tentang cara mendesain sistem yang scalable, reliable, dan maintainable.

## Arsitektur Aplikasi
1.  **Monolithic vs Microservices**
    *   Kelebihan dan kekurangan masing-masing.
    *   Kapan harus migrasi ke microservices?
2.  **Serverless**
    *   Menjalankan kode tanpa memikirkan server.
    *   Event-driven architecture.

## Metodologi
1.  **The Twelve-Factor App**
    *   Panduan untuk membangun aplikasi SaaS modern (Codebase, Dependencies, Config, Backing services, dll).
2.  **GitOps**
    *   Menggunakan Git sebagai "single source of truth" untuk infrastruktur dan aplikasi.
    *   Perubahan infrastruktur dilakukan lewat Pull Request.

## Reliability
1.  **High Availability (HA)**: Sistem tetap jalan meski ada komponen yang mati.
2.  **Scalability**: Vertical Scaling (Upgrade RAM/CPU) vs Horizontal Scaling (Tambah jumlah server).
3.  **Disaster Recovery (DR)**: Rencana pemulihan jika terjadi bencana data center.

## Latihan Praktis
1.  Baca manifesto "The Twelve-Factor App".
2.  Coba refactor aplikasi monolitik sederhana menjadi 2 service terpisah (misal: frontend dan backend API).
3.  Implementasikan strategi GitOps sederhana menggunakan ArgoCD (jika sudah paham Kubernetes).

## Referensi Belajar
*   [The Twelve-Factor App](https://12factor.net/)
*   [Microservices.io](https://microservices.io/)
*   [Google SRE Book](https://sre.google/books/)
