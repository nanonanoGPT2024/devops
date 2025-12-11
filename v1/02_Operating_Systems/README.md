# 02. Konsep Sistem Operasi (Operating Systems)

Pemahaman mendalam tentang Sistem Operasi (terutama Linux) adalah fondasi utama DevOps. Anda harus tahu bagaimana OS bekerja di balik layar.

## Topik Utama
1.  **Manajemen Proses (Process Management)**
    *   Apa itu proses dan thread?
    *   PID, PPID.
    *   Foreground vs Background processes.
    *   Signals (KILL, TERM, HUP).
2.  **Manajemen Memori (Memory Management)**
    *   Virtual Memory, Swap.
    *   OOM (Out of Memory) Killer.
3.  **I/O Management**
    *   File Descriptors (stdin, stdout, stderr).
    *   Buffering.
4.  **File Systems**
    *   Struktur direktori Linux (`/etc`, `/var`, `/usr`, `/proc`).
    *   Permissions (`chmod`, `chown`, `umask`).
    *   Hard link vs Soft link.
5.  **Virtualisasi**
    *   Hypervisors (Type 1 vs Type 2).
    *   Virtual Machines vs Containers.
6.  **Networking Dasar di OS**
    *   Sockets.
    *   Ports.

## Latihan Praktis
1.  Eksplorasi direktori `/proc` di Linux untuk melihat info proses yang berjalan.
2.  Gunakan command `top` atau `htop` untuk menganalisis penggunaan resource.
3.  Coba buat user baru, grup baru, dan atur permission folder agar hanya bisa dibaca oleh grup tersebut.

## Referensi Belajar
*   Buku: *Operating System Concepts* (Dinosaur Book).
*   [Linux Journey](https://linuxjourney.com/)
*   [OSTEP (Operating Systems: Three Easy Pieces)](https://pages.cs.wisc.edu/~remzi/OSTEP/)
