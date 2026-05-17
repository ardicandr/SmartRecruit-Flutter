# SmartRecruit Mobile App

## 📱 Tentang Proyek
SmartRecruit adalah aplikasi mobile pencarian kerja cerdas yang dirancang untuk mempermudah kandidat dalam menemukan pekerjaan, mengelola profil, dan mengikuti proses rekrutmen. Aplikasi ini dibangun menggunakan Flutter dengan mengedepankan desain yang intuitif, arsitektur yang kokoh, serta kode yang maintainable.

---

## 🎨 1. Perancangan & Implementasi Desain UI/UX
Pengembangan aplikasi ini mengikuti tahapan desain UI/UX yang sistematis untuk memastikan produk yang dihasilkan fungsional dan ramah pengguna:
* **Wireframe & Prototype**: Sebelum tahap coding, kami merancang wireframe dasar dan membuat prototype untuk memvalidasi alur navigasi dan tata letak informasi.
* **Konsistensi UI**: Kami menerapkan sistem desain (*Design System*) yang mencakup palet warna yang seragam, tipografi (menggunakan `google_fonts`), dan komponen kustom yang dapat digunakan kembali (*Reusable Components*).
* **Responsivitas**: Tampilan diimplementasikan agar responsif terhadap berbagai rasio dan ukuran layar smartphone, mencegah isu *pixel overflow*.
* **Aset Visual & Fungsional**: Penggunaan ikon vektor (`flutter_svg`) memastikan gambar tidak pecah, serta integrasi visualisasi data sederhana dengan `fl_chart`.

---

## 🏗️ 2. Arsitektur Aplikasi & State Management
Untuk memastikan kode terstruktur, modular, dan mudah dikembangkan dalam jangka panjang, aplikasi ini mengadopsi pemisahan layer (*Separation of Concerns*) yang ketat.

Kami menggunakan arsitektur modular berbasis **GetX Pattern**:
* **State Management**: Menggunakan `GetX` yang reaktif. State logika dipisahkan sepenuhnya dari UI (View) melalui *Controller*, sehingga memudahkan proses *unit testing* dan *debugging*.
* **Pemisahan Layer**: Direktori proyek (`lib/app/`) disusun secara sistematis:
  * `core/`: Berisi tema, utilitas, styling, konstanta, dan konfigurasi utama aplikasi.
  * `data/`: Mengelola komunikasi API/backend (`http`), model data, dan interaksi dengan *local storage* yang aman (`flutter_secure_storage`).
  * `modules/`: Membagi fitur ke dalam direktori independen (contoh: `home`, `login`, `ai_insight`, `upload_cv`, dll). Setiap modul memiliki `Binding`, `Controller`, dan `View` secara spesifik.
  * `routes/`: Pusat manajemen alur navigasi berbasis rute (Named Routes).
* **Navigasi & Dependency Injection**: Alur perpindahan halaman (*routing*) dan injeksi *dependency* (seperti inisialisasi controller) diatur secara otomatis dengan `GetPage` dan `Bindings`, menghindari *memory leak* dan kode *boilerplate* yang berlebihan.

---

## 🔄 3. Version Control & Kolaborasi
Pengembangan aplikasi dilakukan dengan mematuhi praktik pengelolaan versi (*version control*) menggunakan Git:
* **Branching Strategy**: Mengadopsi pengelolaan *branch* yang jelas (pemisahan *branch* utama/`main` dan *branch* fitur) guna memfasilitasi integrasi kode secara aman jika bekerja dalam tim.
* **Commit Terstruktur**: Pesan komit (commit message) ditulis secara jelas, ringkas, dan representatif sesuai konvensi (contoh: `feat: add ai_insight module`, `fix: UI overflow on login screen`).
* **Dokumentasi**: *README* ini dipertahankan dan diperbarui secara berkala sebagai panduan utama terkait arsitektur proyek dan standar teknis.

---

## ⚙️ 4. Keputusan Teknis, Alur Kerja & Problem Solving
Beberapa keputusan teknis utama yang diambil untuk mengatasi tantangan dalam pengembangan proyek ini meliputi:
* **Penggunaan GetX**: Dipilih sebagai solusi *all-in-one* karena mengintegrasikan *state management*, *routing*, dan *dependency injection* dengan performa tinggi. Hal ini memangkas waktu *development* secara signifikan.
* **Pemanfaatan AI & Machine Learning di Device**: Menggunakan pustaka `google_mlkit_text_recognition` untuk melakukan proses ekstraksi teks (*OCR*) langsung pada perangkat. Ini adalah solusi inovatif agar aplikasi dapat membaca CV pengguna tanpa membebani server secara masif.
* **Keamanan Data Sesi**: Daripada menggunakan *Shared Preferences* biasa, kami memilih `flutter_secure_storage` untuk menyimpan *token otentikasi* pengguna guna melindungi data sensitif secara kriptografis dari ancaman eksploitasi.
* **Pemantauan & Logging**: Menggunakan *package* `logger` yang membantu menampilkan dan menganalisis status respons *request* API maupun *error stack trace* secara terstruktur selama tahapan *development* dan *debugging*.

---

## 🚀 Cara Menjalankan Aplikasi di Environtment Lokal

1. **Clone Repositori**:
   ```bash
   git clone <url_repositori_anda>
   ```
2. **Masuk ke Direktori Proyek**:
   ```bash
   cd smart_recruit
   ```
3. **Instal Dependensi**:
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi (Pastikan Emulator/Device sudah aktif)**:
   ```bash
   flutter run
   ```

---
*Dokumentasi disusun untuk memenuhi standar penilaian Mobile Development Capstone Project.*
