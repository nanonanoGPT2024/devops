# 07. CI/CD (Continuous Integration / Continuous Deployment)

CI/CD adalah metode untuk mendistribusikan aplikasi ke pengguna secara sering dengan menggunakan otomatisasi pada tahap building, testing, dan deployment.

## Konsep
1.  **Continuous Integration (CI)**
    *   Pengembang sering melakukan merge kode ke repositori utama (main branch).
    *   Setiap merge memicu build dan test otomatis.
    *   Tujuan: Menemukan bug lebih awal.
2.  **Continuous Delivery (CD)**
    *   Otomatisasi rilis kode ke lingkungan staging/production.
    *   Membutuhkan persetujuan manual sebelum deploy ke production (opsional).
3.  **Continuous Deployment**
    *   Setiap perubahan yang lolos test otomatis langsung di-deploy ke production tanpa intervensi manusia.

## Tools Populer
1.  **Jenkins**
    *   Open source, sangat fleksibel, plugin melimpah.
    *   Kurva belajar agak curam.
2.  **GitLab CI**
    *   Terintegrasi langsung dengan GitLab.
    *   Konfigurasi menggunakan `.gitlab-ci.yml`.
3.  **GitHub Actions**
    *   Terintegrasi dengan GitHub.
    *   Marketplace action yang besar.
    *   Gratis untuk repositori publik.
4.  **CircleCI / Travis CI** (SaaS based).

## Latihan Praktis
1.  Buat repositori di GitHub.
2.  Buat workflow GitHub Actions sederhana yang menjalankan linter atau unit test setiap kali ada push.
3.  Buat pipeline yang mem-build Docker image dan push ke Docker Hub setiap kali ada rilis baru.

## Referensi Belajar
*   [GitHub Actions Documentation](https://docs.github.com/en/actions)
*   [GitLab CI/CD Documentation](https://docs.gitlab.com/ee/ci/)
*   [Jenkins User Documentation](https://www.jenkins.io/doc/)
