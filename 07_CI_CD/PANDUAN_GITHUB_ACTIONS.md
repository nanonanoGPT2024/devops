# Panduan Lengkap CI/CD (GitHub Actions)

CI/CD adalah jantung dari otomatisasi DevOps. Kita akan fokus pada **GitHub Actions** karena gratis, populer, dan mudah dipelajari.

## 1. Anatomi GitHub Actions
Workflow didefinisikan dalam file YAML di folder `.github/workflows/`.

Komponen utama:
*   **Events (on)**: Kapan workflow jalan? (misal: saat ada `push` ke branch `main`).
*   **Jobs**: Kumpulan tugas.
*   **Steps**: Langkah-langkah kecil dalam job (misal: checkout code, install python, run test).
*   **Runners**: Server yang menjalankan job (biasanya `ubuntu-latest`).

## 2. Contoh Workflow: Python CI
Skenario: Setiap kali ada kode baru di-push, kita ingin otomatis menjalankan Unit Test.

File: `.github/workflows/python-test.yml`

```yaml
name: Python Application Test

# Trigger: Jalan saat push ke main atau pull request
on:
  push:
    branches: [ "main" ]
  pull_request:
    branches: [ "main" ]

jobs:
  build-and-test:
    runs-on: ubuntu-latest

    steps:
    # 1. Ambil kode dari repo
    - name: Checkout code
      uses: actions/checkout@v3

    # 2. Siapkan Python
    - name: Set up Python 3.9
      uses: actions/setup-python@v4
      with:
        python-version: "3.9"

    # 3. Install dependencies
    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
        pip install pytest

    # 4. Jalankan Test
    - name: Test with pytest
      run: |
        pytest
```

## 3. Contoh Workflow: Build & Push Docker Image (CD)
Skenario: Jika test lolos, build Docker image dan push ke Docker Hub.

File: `.github/workflows/docker-publish.yml`

```yaml
name: Build and Push Docker Image

on:
  push:
    tags:
      - 'v*' # Jalan hanya kalau kita push tag version (misal v1.0)

jobs:
  docker:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Login to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}
      
      - name: Build and push
        uses: docker/build-push-action@v4
        with:
          context: .
          push: true
          tags: user/app:latest
```

> **Catatan**: `secrets.DOCKERHUB_USERNAME` diatur di menu Settings > Secrets and variables > Actions di repository GitHub Anda. Jangan pernah tulis password di file YAML!

## 4. Konsep Pipeline
Pipeline yang baik biasanya memiliki tahapan:
1.  **Linting**: Cek kerapian kode (Flake8, ESLint).
2.  **Testing**: Unit test, Integration test.
3.  **Security Scan**: Cek kerentanan (Snyk, SonarQube).
4.  **Build**: Buat artifact (Docker image, Binary).
5.  **Deploy**: Kirim ke Staging/Production.

## 5. Latihan Praktis
1.  Buat repo baru di GitHub.
2.  Upload script python sederhana dan file `test_script.py`.
3.  Buat file `.github/workflows/main.yml` dengan isi seperti contoh di atas.
4.  Push ke GitHub dan lihat tab "Actions". Apakah centang hijau?
