# 03. Terminal & Scripting

Anda akan menghabiskan sebagian besar waktu Anda di terminal. Menguasai command line dan scripting adalah wajib.

## Shell Scripting (Bash/Zsh)
Bash adalah bahasa scripting default di banyak sistem Linux.

### Materi Pembelajaran
1.  **Basic Commands**: `ls`, `cd`, `pwd`, `cp`, `mv`, `rm`, `mkdir`, `touch`.
2.  **File Manipulation**: `cat`, `head`, `tail`, `less`, `grep`, `sed`, `awk`, `find`.
3.  **Text Processing**: Pipa (`|`) dan Redirection (`>`, `>>`, `<`).
4.  **Scripting Basics**:
    *   Shebang (`#!/bin/bash`).
    *   Variables.
    *   Loops (`for`, `while`).
    *   Conditions (`if`, `else`).
    *   Functions.
5.  **Networking Commands**: `curl`, `wget`, `ping`, `telnet`, `nc` (netcat), `ssh`, `scp`.
6.  **System Monitoring**: `ps`, `top`, `df`, `du`, `free`, `lsof`.

## PowerShell (Opsional tapi Bagus)
Jika Anda bekerja di lingkungan Windows atau Azure, PowerShell sangat powerful.

## Editor Teks
Pelajari setidaknya satu editor berbasis terminal:
*   **Vim/Neovim**: Sangat powerful, ada di hampir semua server.
*   **Nano**: Lebih mudah digunakan untuk pemula.

## Latihan Praktis
1.  Buat script backup otomatis yang meng-zip folder tertentu dan memberinya nama berdasarkan tanggal hari ini.
2.  Gunakan `grep` dan `awk` untuk mencari IP address yang paling sering mengakses server dari file log.
3.  Konfigurasi SSH Key-based authentication antara dua mesin (atau VM).

## Referensi Belajar
*   [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
*   [Vim Adventures](https://vim-adventures.com/)
*   [ExplainShell.com](https://explainshell.com/)
