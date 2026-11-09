
# TaskMate - Aplikasi Manajemen Tugas Kuliah

## Deskripsi
TaskMate merupakan aplikasi mobile berbasis Flutter yang
dirancang untuk membantu mahasiswa mengelola tugas kuliah.
Aplikasi ini menyediakan fitur pencatatan tugas, pengelolaan
deadline, status pengerjaan, serta ringkasan tugas.

## Identitas Mahasiswa
- Nama: [GEDE RIFKI SWASTIKA UTAMA]
- NIM: [2415051095]
- Kelas: [Pendidikan Teknik Informatika 5A]
- Mata Kuliah: Pemrograman Mobile

## Fitur Aplikasi
1. Dashboard ringkasan tugas.
2. Menambahkan tugas kuliah.
3. Melihat daftar dan detail tugas.
4. Mengedit data tugas.
5. Menghapus tugas dengan konfirmasi.
6. Mengelola status pengerjaan.
7. Motivasi belajar dari REST API.
8. Tampilan responsif untuk HP dan tablet.

## Teknologi yang Digunakan
- Flutter
- Dart
- Provider
- ChangeNotifier
- Supabase
- PostgreSQL
- DummyJSON REST API
- Git dan GitHub

## REST API
Aplikasi menggunakan DummyJSON Quotes API untuk
mengambil data motivasi belajar menggunakan HTTP GET.
Data JSON dikonversi menjadi Dart Model dan ditampilkan
pada halaman Home.

## Backend dan Database
Aplikasi menggunakan Supabase dengan PostgreSQL.

Tabel utama: tasks

Kolom:
- id (UUID, Primary Key)
- user_id
- title
- description
- deadline
- status
- created_at

Operasi database:
- Create
- Read
- Update
- Delete

Keamanan database menggunakan Row Level Security (RLS).

## Arsitektur Aplikasi
UI / Screens
       |
       v
Provider / ChangeNotifier
       |
       v
Repository
       |
       v
Service / Data Source
       |
       v
Supabase Database / REST API

## Struktur Folder
lib/
├── config/
├── models/
├── services/
├── repositories/
├── providers/
├── screens/
├── widgets/
└── main.dart

## Cara Menjalankan Aplikasi

1. Pastikan Flutter sudah terpasang.
2. Clone repository:

   git clone https://github.com/rifkisuastika18-crypto/UTS-2415051095-RIFKI.git

3. Masuk ke folder proyek:

   cd UTS-2415051095-RIFKI

4. Instal dependencies:

   flutter pub get

5. Atur Project URL dan Publishable Key Supabase
   pada lib/config/supabase_config.dart.

6. Jalankan aplikasi:

   flutter run

## Screenshot Aplikasi
Screenshot aplikasi akan disimpan pada folder
docs/screenshots/.

- Home
- Daftar Tugas
- Detail Tugas
- Tambah Tugas
- Edit Tugas
- Responsive Layout
- Motivasi Belajar
- Supabase Database

## Repository
https://github.com/rifkisuastika18-crypto/UTS-2415051095-RIFKI
