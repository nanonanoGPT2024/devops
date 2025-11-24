# Panduan Lengkap Version Control (Git)

Sebelum masuk ke coding dan server, skill paling fundamental adalah **Git**. DevOps Engineer bekerja dalam tim, dan Git adalah cara kita berkolaborasi.

## 1. Konsep Dasar Git

*   **Repository (Repo)**: Folder proyek yang dilacak oleh Git.
*   **Commit**: Snapshot/foto dari kode pada waktu tertentu.
*   **Branch**: Cabang paralel untuk mengerjakan fitur tanpa mengganggu kode utama.
*   **Merge**: Menggabungkan cabang kembali ke utama.
*   **Remote**: Versi repo yang disimpan di server (GitHub/GitLab).

## 2. Git Cheatsheet (Wajib Hafal)

### Setup Awal
```bash
git config --global user.name "Nama Anda"
git config --global user.email "email@anda.com"
```

### Flow Sehari-hari
```bash
# 1. Mulai repo baru
git init

# 2. Cek status (file apa yang berubah?)
git status

# 3. Masukkan file ke staging area
git add .           # Semua file
git add file.py     # File tertentu saja

# 4. Simpan perubahan (Commit)
git commit -m "Menambahkan fitur login"

# 5. Lihat riwayat
git log --oneline
```

### Bekerja dengan Remote (GitHub)
```bash
# Clone repo orang lain
git clone https://github.com/user/repo.git

# Upload perubahan kita
git push origin main

# Ambil perubahan orang lain
git pull origin main
```

---

## 3. Branching Strategy (Strategi Percabangan)

Di dunia kerja, kita tidak boleh asal push ke `main`. Kita pakai strategi.

### A. Feature Branch Workflow (Paling Umum)
1.  Jangan sentuh branch `main` langsung.
2.  Buat branch baru untuk setiap fitur: `git checkout -b fitur-login`.
3.  Coding di situ sampai selesai.
4.  Push branch fitur ke GitHub.
5.  Buat **Pull Request (PR)** untuk minta review teman.
6.  Jika oke, baru di-merge ke `main`.

### B. Git Flow (Lebih Kompleks)
Memiliki branch khusus: `main` (production), `develop` (staging), `feature/*`, `release/*`, `hotfix/*`.

---

## 4. Mengatasi Konflik (Merge Conflict)
Terjadi saat dua orang mengedit baris yang sama di file yang sama.

1.  Git akan bilang "CONFLICT".
2.  Buka file yang konflik. Anda akan lihat tanda `<<<<<<<`, `=======`, `>>>>>>>`.
3.  Pilih kode mana yang benar (hapus tanda-tanda Git tadi).
4.  `git add file_yang_sudah_diperbaiki`.
5.  `git commit`.

---

## 5. Latihan Praktis
1.  Buat folder `belajar-git`. `git init`.
2.  Buat file `index.html`. Commit.
3.  Buat branch `fitur-warna`. Ganti warna background di file itu. Commit.
4.  Pindah balik ke `main`. Lihat warnanya kembali seperti semula.
5.  Merge `fitur-warna` ke `main`.
