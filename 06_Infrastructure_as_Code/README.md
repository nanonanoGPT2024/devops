# 06. Infrastructure as Code (IaC)

IaC adalah praktik mengelola infrastruktur (server, network, load balancer) menggunakan kode dan file konfigurasi, bukan konfigurasi manual.

## Containerization
1.  **Docker**
    *   Memaketkan aplikasi beserta dependensinya ke dalam container.
    *   Konsep: Image, Container, Dockerfile, Docker Compose.
    *   Networking & Volumes di Docker.

## Container Orchestration
1.  **Kubernetes (K8s)**
    *   Standar industri untuk mengelola container dalam skala besar.
    *   Konsep: Pod, Service, Deployment, Ingress, ConfigMap, Secret.
    *   Tools: `kubectl`, `minikube`, `helm`.

## Infrastructure Provisioning
1.  **Terraform**
    *   Tool agnostik cloud untuk membuat infrastruktur.
    *   Menggunakan HCL (HashiCorp Configuration Language).
    *   Konsep: Provider, Resource, State file, Module.

## Configuration Management
1.  **Ansible**
    *   Agentless (menggunakan SSH).
    *   Menggunakan YAML untuk Playbook.
    *   Cocok untuk konfigurasi server (install paket, update config).

## Latihan Praktis
1.  **Docker**: Buat Dockerfile untuk aplikasi sederhana, build image, dan jalankan containernya.
2.  **Docker Compose**: Jalankan aplikasi web + database menggunakan `docker-compose.yml`.
3.  **Terraform**: Gunakan Terraform untuk membuat EC2 instance di AWS (atau VM lokal jika pakai provider lain).
4.  **Ansible**: Buat playbook untuk menginstall Nginx di server target.

## Referensi Belajar
*   [Docker Documentation](https://docs.docker.com/)
*   [Kubernetes Documentation](https://kubernetes.io/docs/home/)
*   [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
*   [Ansible Documentation](https://docs.ansible.com/)
