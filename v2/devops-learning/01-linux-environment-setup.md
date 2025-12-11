# Materi Pembelajaran: Setup Linux Development Environment

> **Workflow**: `/01-setup-linux-env`  
> **Durasi**: 2-3 jam  
> **Level**: Beginner  
> **Prerequisites**: Windows 10/11 dengan WSL2 atau VM dengan Ubuntu

---

## 📚 Daftar Isi

1. [Pengenalan Linux untuk DevOps](#pengenalan-linux)
2. [Setup WSL2 di Windows](#setup-wsl2)
3. [Linux Command Basics](#linux-commands)
4. [Package Management](#package-management)
5. [Git Installation & Configuration](#git-setup)
6. [Docker Installation](#docker-setup)
7. [SSH Key Management](#ssh-keys)
8. [Hands-On Exercises](#exercises)
9. [Troubleshooting](#troubleshooting)

---

## 1. Pengenalan Linux untuk DevOps

### Mengapa Linux?

**Linux adalah fondasi DevOps** karena:
- Mayoritas server production menggunakan Linux
- Docker container berbasis Linux
- Kubernetes dirancang untuk Linux
- Tools DevOps kebanyakan first-class di Linux
- Open source dan gratis

### Distro Linux yang Umum

| Distro | Use Case | Package Manager |
|--------|----------|----------------|
| Ubuntu | Development, Server | apt |
| Debian | Server, Stability | apt |
| CentOS/RHEL | Enterprise Server | yum/dnf |
| Alpine | Docker Images | apk |

**Untuk pembelajaran, kita pakai Ubuntu** karena:
- User-friendly untuk pemula
- Dokumentasi lengkap
- Compatible dengan WSL2
- Banyak tutorial tersedia

---

## 2. Setup WSL2 di Windows

### Apa itu WSL2?

**WSL2 (Windows Subsystem for Linux 2)** adalah fitur Windows yang memungkinkan Anda menjalankan Linux environment langsung di Windows tanpa VM.

**Keuntungan WSL2**:
- Performa mendekati native Linux
- Integrasi dengan Windows (akses file kedua system)
- Ringan (tidak butuh full VM)
- Perfect untuk development

### Instalasi WSL2

#### Step 1: Enable WSL
```powershell
# Run as Administrator di PowerShell
wsl --install
```

Command ini akan:
- Enable WSL feature
- Install Ubuntu secara default
- Setup WSL2 sebagai default version

#### Step 2: Restart Komputer
Setelah install, **restart** komputer Anda.

#### Step 3: Setup Ubuntu
Setelah restart, Ubuntu akan launch otomatis:
1. Buat username (lowercase, no spaces)
2. Buat password (tidak terlihat saat mengetik, ini normal!)
3. Confirm password

```bash
# Contoh:
Enter new UNIX username: devuser
New password: ********
Retype new password: ********
```

#### Step 4: Verifikasi WSL2
```powershell
# Di PowerShell/CMD Windows
wsl --list --verbose
```

Output yang diharapkan:
```
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

### Akses WSL2

**Cara 1: Windows Terminal**
```powershell
wsl
# atau
wsl -d Ubuntu
```

**Cara 2: Shortcut**
- Buka Start Menu → Ketik "Ubuntu" → Enter

**Cara 3: VSCode**
- Install extension "Remote - WSL"
- Open folder in WSL dari VSCode

---

## 3. Linux Command Basics

### File System Structure

Linux menggunakan **tree structure** berbeda dari Windows:

```
/                    # Root directory (bukan C:\)
├── home/           # User home directories
│   └── username/   # Your home (~)
├── etc/            # Configuration files
├── var/            # Variable data (logs, caches)
├── usr/            # User programs
├── bin/            # Essential binaries
└── tmp/            # Temporary files
```

### Essential Commands

#### Navigasi Directory

```bash
# Print Working Directory - lihat lokasi current
pwd

# Change Directory
cd /home/username    # Absolute path
cd Documents         # Relative path
cd ..               # Naik 1 level
cd ~                # Ke home directory
cd -                # Ke directory sebelumnya

# List files
ls                  # List files
ls -l               # Long format (detailed)
ls -la              # Include hidden files
ls -lh              # Human readable sizes
```

**Praktik:**
```bash
# Coba command ini step by step
pwd                      # Lihat posisi awal
cd /                     # Pindah ke root
ls -la                   # Lihat isi root
cd ~                     # Balik ke home
mkdir devops-learning    # Buat folder
cd devops-learning       # Masuk ke folder
pwd                      # Verify posisi
```

#### File Operations

```bash
# Create file
touch filename.txt
echo "Hello DevOps" > file.txt    # Create dengan content

# View file content
cat file.txt                       # Print semua content
less file.txt                      # View dengan pagination
head -n 10 file.txt               # 10 baris pertama
tail -n 10 file.txt               # 10 baris terakhir
tail -f file.txt                   # Follow (realtime)

# Copy, Move, Delete
cp source.txt destination.txt      # Copy file
cp -r folder1 folder2              # Copy directory
mv oldname.txt newname.txt         # Rename/Move
rm file.txt                        # Delete file
rm -rf folder/                     # Delete folder (HATI-HATI!)

# Create directory
mkdir folder_name
mkdir -p parent/child/grandchild   # Create nested
```

**Praktik:**
```bash
# Exercise: File manipulation
cd ~/devops-learning
echo "Belajar DevOps hari ini" > notes.txt
cat notes.txt
cp notes.txt notes_backup.txt
ls -l
mkdir backup
mv notes_backup.txt backup/
ls -la backup/
```

#### Search & Filter

```bash
# Find files
find . -name "*.txt"               # Cari file .txt
find /home -type d -name "devops"  # Cari directory

# Search in files
grep "error" logfile.txt           # Cari kata "error"
grep -i "error" logfile.txt        # Case insensitive
grep -r "TODO" .                   # Recursive di semua files

# Pipe & Filter
ls -l | grep "txt"                 # List hanya .txt files
cat file.txt | grep "error"        # Filter content
ps aux | grep "docker"             # Find process
```

---

## 4. Package Management

### APT (Advanced Package Tool)

**APT** adalah package manager untuk Ubuntu/Debian.

#### Update Package Repository

```bash
# SELALU jalankan ini sebelum install packages
sudo apt update
```

**Apa yang terjadi?**
- Download daftar package terbaru dari repository
- Cek versi terbaru yang tersedia
- TIDAK install/upgrade packages

#### Upgrade Installed Packages

```bash
# Upgrade semua installed packages
sudo apt upgrade -y
# -y = auto yes (no confirmation)
```

**Kapan upgrade?**
- Setelah fresh install
- Maintenance rutin (1-2 minggu sekali)
- Sebelum install package baru

#### Install Packages

```bash
# Install single package
sudo apt install git

# Install multiple packages
sudo apt install git curl wget vim

# Install tanpa confirmation
sudo apt install -y package_name
```

#### Useful APT Commands

```bash
# Search package
apt search keyword

# Show package info
apt show package_name

# Remove package
sudo apt remove package_name

# Remove package + config files
sudo apt purge package_name

# Remove unused dependencies
sudo apt autoremove
```

---

## 5. Git Installation & Configuration

### Install Git

```bash
sudo apt update
sudo apt install -y git
```

### Verifikasi Installation

```bash
git --version
# Output: git version 2.43.0
```

### Konfigurasi Git

**WAJIB** setup identity sebelum commit pertama:

```bash
# Set nama (akan muncul di commit history)
git config --global user.name "Nama Lengkap Anda"

# Set email
git config --global user.email "email@anda.com"

# Set default editor
git config --global core.editor "vim"

# Set default branch name
git config --global init.defaultBranch main
```

### Verifikasi Konfigurasi

```bash
# Lihat semua config
git config --list

# Lihat config spesifik
git config user.name
git config user.email
```

### Test Git

```bash
# Buat test repository
mkdir test-repo
cd test-repo
git init

# Buat file dan commit
echo "# Test Repo" > README.md
git add README.md
git commit -m "Initial commit"

# Lihat log
git log
```

---

## 6. Docker Installation

### Install Docker di Ubuntu/WSL2

#### Step 1: Install Prerequisites

```bash
sudo apt update
sudo apt install -y ca-certificates curl gnupg lsb-release
```

#### Step 2: Add Docker GPG Key

```bash
# Buat directory untuk keyrings
sudo mkdir -p /etc/apt/keyrings

# Download dan add GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```

**Apa itu GPG Key?**
- Untuk verify authenticity packages
- Pastikan packages from official Docker repository
- Security measure

#### Step 3: Add Docker Repository

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

#### Step 4: Install Docker

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

**Packages yang diinstall:**
- `docker-ce`: Docker Engine
- `docker-ce-cli`: Command line interface
- `containerd.io`: Container runtime
- `docker-buildx-plugin`: Build images
- `docker-compose-plugin`: Multi-container apps

#### Step 5: Add User to Docker Group

```bash
# Add current user ke docker group
sudo usermod -aG docker $USER

# Verify group
groups

# PENTING: Logout dan login kembali agar perubahan aktif
# Atau jalankan:
newgrp docker
```

**Mengapa perlu ini?**
- Secara default, Docker commands butuh sudo
- Dengan add ke docker group, bisa run tanpa sudo
- Best practice untuk development

### Verifikasi Docker

```bash
# Check Docker version
docker --version

# Check Docker Compose
docker compose version

# Run test container
docker run hello-world
```

**Output yang diharapkan:**
```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

### Test Docker dengan Real Container

```bash
# Run Nginx
docker run -d -p 8080:80 --name test-nginx nginx:alpine

# Verify
docker ps

# Test di browser atau curl
curl http://localhost:8080

# Cleanup
docker stop test-nginx
docker rm test-nginx
```

---

## 7. SSH Key Management

### Mengapa Perlu SSH Keys?

SSH keys digunakan untuk:
- Authentication ke GitHub/GitLab tanpa password
- SSH ke remote servers
- Secure communication

### Generate SSH Key

```bash
# Generate ED25519 key (recommended)
ssh-keygen -t ed25519 -C "email@anda.com"
```

**Prompts:**
```
Enter file in which to save the key: [tekan Enter - use default]
Enter passphrase (empty for no passphrase): [optional - tekan Enter to skip]
Enter same passphrase again: [tekan Enter]
```

**Output:**
```
Your identification has been saved in /home/user/.ssh/id_ed25519
Your public key has been saved in /home/user/.ssh/id_ed25519.pub
```

### View Public Key

```bash
# Print public key (untuk copy ke GitHub)
cat ~/.ssh/id_ed25519.pub
```

**Format public key:**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIxxx... email@anda.com
```

### Add Key to SSH Agent

```bash
# Start SSH agent
eval "$(ssh-agent -s)"

# Add private key
ssh-add ~/.ssh/id_ed25519
```

### Add to GitHub

1. Copy public key: `cat ~/.ssh/id_ed25519.pub`
2. Buka GitHub → Settings → SSH and GPG keys
3. Click "New SSH key"
4. Paste key dan save

### Test SSH Connection

```bash
# Test GitHub connection
ssh -T git@github.com
```

**Success output:**
```
Hi username! You've successfully authenticated, but GitHub does not provide shell access.
```

---

## 8. Hands-On Exercises

### Exercise 1: Linux Command Mastery

**Objective**: Practice basic Linux commands

```bash
# 1. Create project structure
cd ~
mkdir -p projects/devops-learning/{scripts,configs,logs}

# 2. Navigate and create files
cd projects/devops-learning/scripts
echo '#!/bin/bash' > hello.sh
echo 'echo "Hello DevOps!"' >> hello.sh
chmod +x hello.sh

# 3. Test script
./hello.sh

# 4. Find and list
cd ~/projects
find . -name "*.sh"
ls -R

# 5. Create log file
echo "$(date): Started learning DevOps" > ../logs/learning.log
cat ../logs/learning.log
```

**Verification:**
- [ ] Berhasil create folder structure
- [ ] Script hello.sh berjalan
- [ ] File log terisi dengan timestamp

---

### Exercise 2: Git Workflow

**Objective**: Practice basic Git operations

```bash
# 1. Create repository
cd ~/projects
mkdir my-first-repo
cd my-first-repo
git init

# 2. Create files
echo "# My DevOps Journey" > README.md
echo "Learning Git basics" >> README.md

# 3. Stage and commit
git add README.md
git commit -m "feat: initial commit with README"

# 4. Create branch
git checkout -b feature/add-notes
echo "## Day 1 Notes" >> README.md
echo "- Learned Linux commands" >> README.md
git add README.md
git commit -m "docs: add day 1 notes"

# 5. Merge to main
git checkout main
git merge feature/add-notes

# 6. View history
git log --oneline --graph
```

**Verification:**
- [ ] Repository initialized
- [ ] Commit history terlihat
- [ ] Branch merge berhasil

---

### Exercise 3: Docker Basics

**Objective**: Run and manage containers

```bash
# 1. Run Ubuntu container interactively
docker run -it ubuntu:22.04 bash

# Inside container:
apt update
apt install -y curl
curl --version
exit

# 2. Run background container
docker run -d --name my-nginx -p 8080:80 nginx:alpine

# 3. Verify running
docker ps

# 4. View logs
docker logs my-nginx

# 5. Execute command in container
docker exec my-nginx ls /usr/share/nginx/html

# 6. Stop and remove
docker stop my-nginx
docker rm my-nginx

# 7. Cleanup
docker system prune -f
```

**Verification:**
- [ ] Container berjalan
- [ ] Bisa akses http://localhost:8080
- [ ] Logs terlihat
- [ ] Cleanup berhasil

---

### Exercise 4: Build Custom Docker Image

**Objective**: Create Dockerfile and build image

```bash
# 1. Create project
cd ~/projects
mkdir docker-practice
cd docker-practice

# 2. Create simple app
cat > app.py << 'EOF'
from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello from Docker!\n"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
EOF

# 3. Create requirements
echo "flask==3.0.0" > requirements.txt

# 4. Create Dockerfile
cat > Dockerfile << 'EOF'
FROM python:3.11-alpine

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
EOF

# 5. Build image
docker build -t my-flask-app:v1 .

# 6. Run container
docker run -d -p 5000:5000 --name flask-app my-flask-app:v1

# 7. Test
curl http://localhost:5000

# 8. Cleanup
docker stop flask-app
docker rm flask-app
```

**Verification:**
- [ ] Image berhasil dibuild
- [ ] Container running
- [ ] Aplikasi respond di port 5000
- [ ] Cleanup berhasil

---

## 9. Troubleshooting

### Common Issues & Solutions

#### Issue 1: WSL2 Not Starting

**Error**: "The system cannot find the file specified"

**Solution**:
```powershell
# Enable WSL feature
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# Enable Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Restart komputer
```

---

#### Issue 2: Permission Denied

**Error**: "Permission denied" saat run command

**Solution**:
```bash
# Jika file, add execute permission
chmod +x filename.sh

# Jika butuh sudo, tambahkan sudo
sudo command_here
```

---

#### Issue 3: Docker Command Not Found

**Error**: "docker: command not found"

**Solution**:
```bash
# Verify Docker installed
which docker

# If not installed, reinstall
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

---

#### Issue 4: Docker Permission Denied

**Error**: "permission denied while trying to connect to the Docker daemon socket"

**Solution**:
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Logout dan login kembali, atau:
newgrp docker

# Test
docker ps
```

---

#### Issue 5: Port Already in Use

**Error**: "Bind for 0.0.0.0:8080 failed: port is already allocated"

**Solution**:
```bash
# Find process using port
sudo lsof -i :8080

# Kill process
sudo kill -9 <PID>

# Or change port
docker run -p 8081:80 nginx
```

---

## 📝 Checklist Completion

Setelah menyelesaikan materi ini, Anda harus bisa:

### Linux Basics
- [ ] Navigate directory dengan cd, ls, pwd
- [ ] Create, copy, move, delete files
- [ ] Understand file permissions
- [ ] Use grep, find untuk search

### Package Management
- [ ] Update repository dengan apt update
- [ ] Install packages dengan apt install
- [ ] Search dan remove packages

### Git
- [ ] Configure Git identity
- [ ] Create repository
- [ ] Add, commit, push changes
- [ ] Create dan merge branches

### Docker
- [ ] Run containers (interactive & detached)
- [ ] Build custom images
- [ ] Manage containers (start, stop, remove)
- [ ] Use Docker Compose

### SSH
- [ ] Generate SSH keys
- [ ] Add key to GitHub
- [ ] SSH authentication berhasil

---

## 🎯 Next Steps

Setelah berhasil setup environment:

1. **Practice Daily**: Gunakan Linux commands setiap hari
2. **Build Projects**: Containerize aplikasi sederhana
3. **Lanjut Workflow**: `/02-git-basics`
4. **Read Docs**: Git official docs, Docker docs

---

## 📚 Resources Tambahan

### Documentation
- [Ubuntu Documentation](https://ubuntu.com/server/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Git Documentation](https://git-scm.com/doc)

### Interactive Learning
- [Linux Journey](https://linuxjourney.com/)
- [Play with Docker](https://labs.play-with-docker.com/)
- [GitHub Learning Lab](https://lab.github.com/)

### Cheat Sheets
- [Linux Command Cheat Sheet](https://www.linuxtrainingacademy.com/linux-commands-cheat-sheet/)
- [Docker Cheat Sheet](https://docs.docker.com/get-started/docker_cheatsheet.pdf)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

---

**Selamat! Anda sudah menyelesaikan setup Linux Environment untuk DevOps! 🎉**

Lanjut ke materi berikutnya: `/02-git-basics`
