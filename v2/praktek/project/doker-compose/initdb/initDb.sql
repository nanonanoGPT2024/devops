-- Buat database baru
CREATE DATABASE myappdb;

-- Pindah ke database
\c myappdb;

-- Buat tabel user
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT NOW()
);

-- Tambah data dummy
INSERT INTO users (name, email) VALUES
('Nano', 'nano@example.com'),
('Keti', 'keti@example.com'),
('Alice', 'alice@example.com');
