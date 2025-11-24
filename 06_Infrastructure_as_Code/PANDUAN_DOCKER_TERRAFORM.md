# Panduan Lengkap Infrastructure as Code (Docker & Terraform)

IaC mengubah cara kita mengelola infrastruktur: dari "klik-klik manual" menjadi "tulis kode".

## BAGIAN 1: Docker (Containerization)

Docker memaketkan aplikasi Anda agar bisa jalan di mana saja ("It works on my machine" -> "It works everywhere").

### 1. Dockerfile Cheatsheet
Dockerfile adalah resep untuk membuat Image.

```dockerfile
# 1. Base Image (Mulai dari OS/Env apa?)
FROM python:3.9-slim

# 2. Working Directory (Folder kerja di dalam container)
WORKDIR /app

# 3. Copy file requirements dulu (untuk caching layer)
COPY requirements.txt .

# 4. Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy sisa kode aplikasi
COPY . .

# 6. Expose port (Dokumentasi saja)
EXPOSE 5000

# 7. Command untuk menjalankan aplikasi
CMD ["python", "app.py"]
```

### 2. Docker Commands Wajib
| Command | Fungsi |
| :--- | :--- |
| `docker build -t myapp:v1 .` | Membuat image dari Dockerfile saat ini. |
| `docker run -d -p 80:5000 myapp:v1` | Menjalankan container. Port 80 host -> 5000 container. |
| `docker ps` | Lihat container yang sedang jalan. |
| `docker logs -f <container_id>` | Lihat log aplikasi. |
| `docker stop <container_id>` | Matikan container. |
| `docker exec -it <id> bash` | Masuk ke dalam terminal container (SSH-like). |

### 3. Docker Compose
Mengelola multi-container (misal: Web + Database) dengan satu file YAML.

File: `docker-compose.yml`
```yaml
version: '3.8'
services:
  web:
    build: .
    ports:
      - "5000:5000"
    depends_on:
      - db
  
  db:
    image: postgres:13
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: mydb
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```
Cara pakai: `docker-compose up -d` (Jalan di background).

---

## BAGIAN 2: Terraform (Infrastructure Provisioning)

Terraform digunakan untuk membuat server (VM), database, network di Cloud (AWS/GCP/Azure) lewat kode.

### 1. Konsep Dasar
*   **Provider**: Plugin untuk cloud tertentu (misal: AWS).
*   **Resource**: Komponen yang mau dibuat (misal: `aws_instance`).
*   **State**: File database Terraform yang mencatat apa yang sudah dibuat.

### 2. Contoh Script Terraform (AWS)
File: `main.tf`

```hcl
provider "aws" {
  region = "us-east-1"
}

# Membuat Security Group (Firewall)
resource "aws_security_group" "web_sg" {
  name = "allow_http"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Membuat EC2 Instance (Server)
resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0" # ID image Ubuntu
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web_sg.name]

  tags = {
    Name = "Server-DevOps-Belajar"
  }
}
```

### 3. Workflow Terraform
1.  `terraform init`: Download provider (plugin AWS).
2.  `terraform plan`: Simulasi. "Saya akan membuat 1 server dan 1 firewall. Setuju?".
3.  `terraform apply`: Eksekusi. Membuat infrastruktur beneran.
4.  `terraform destroy`: Menghapus semua infrastruktur (Cleanup).

## 4. Latihan Praktis
1.  Install Docker Desktop.
2.  Buat file `index.html` sederhana.
3.  Buat `Dockerfile` yang menggunakan `FROM nginx:alpine` dan `COPY index.html /usr/share/nginx/html`.
4.  Build dan Run container tersebut. Akses di browser.
