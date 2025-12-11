# Panduan Lengkap Kubernetes (K8s)

Jika Docker adalah "batu bata", maka Kubernetes adalah "arsitek" yang menyusun batu bata itu menjadi gedung pencakar langit.

## 1. Konsep Inti K8s
Kubernetes (K8s) adalah *Container Orchestrator*. Dia mengurus deployment, scaling, dan management container secara otomatis.

*   **Pod**: Unit terkecil di K8s. Biasanya berisi 1 container (misal: container aplikasi web).
*   **Node**: Server fisik/VM tempat Pod berjalan (Worker).
*   **Cluster**: Kumpulan Node yang dikendalikan oleh Control Plane (Master).
*   **Service**: "Pintu gerbang" jaringan agar Pod bisa diakses (karena IP Pod sering berubah-ubah).
*   **Deployment**: Blueprint yang mengatur "Saya mau 3 replika Pod aplikasi ini". Jika 1 mati, K8s otomatis buat 1 lagi.
*   **Ingress**: Router HTTP/HTTPS yang mengatur akses dari internet ke Service.

---

## 2. K8s Manifests (YAML)
Kita bicara dengan K8s pakai file YAML.

### Contoh Deployment (Menjalankan Aplikasi)
File: `deployment.yaml`
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3 # Saya mau 3 kembaran
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```

### Contoh Service (Membuka Akses)
File: `service.yaml`
```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx # Sambungkan ke Pod yang labelnya 'nginx'
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: LoadBalancer # Minta IP Public (jika di Cloud)
```

---

## 3. Kubectl Cheatsheet
`kubectl` adalah remote control untuk K8s Cluster.

| Command | Fungsi |
| :--- | :--- |
| `kubectl apply -f file.yaml` | Kirim instruksi (deploy) ke cluster. |
| `kubectl get pods` | Lihat daftar Pod yang jalan. |
| `kubectl get svc` | Lihat daftar Service (dan IP-nya). |
| `kubectl logs <nama-pod>` | Lihat log aplikasi di dalam pod. |
| `kubectl exec -it <nama-pod> -- bash` | Masuk ke dalam terminal pod. |
| `kubectl delete -f file.yaml` | Hapus apa yang dibuat tadi. |

---

## 4. Helm (Package Manager for K8s)
Menulis YAML manual itu capek. Helm seperti "App Store" atau `apt/yum` buat K8s.

*   `helm repo add bitnami https://charts.bitnami.com/bitnami`
*   `helm install my-mysql bitnami/mysql` -> Otomatis deploy MySQL lengkap dengan password, storage, service, dll.

---

## 5. Latihan Praktis (Minikube)
Karena K8s butuh cluster, kita pakai **Minikube** (K8s satu node di laptop).

1.  Install Minikube & Kubectl.
2.  `minikube start`.
3.  Buat file `deployment.yaml` di atas.
4.  `kubectl apply -f deployment.yaml`.
5.  Cek: `kubectl get pods`. Tunggu sampai status `Running`.
6.  Expose: `kubectl expose deployment nginx-deployment --type=NodePort --port=80`.
7.  Akses: `minikube service nginx-deployment`. Browser akan terbuka menampilkan Nginx.
