# Mood Jurnal

## Deskripsi

**Mood Jurnal** adalah aplikasi mobile yang dirancang untuk membantu pengguna melacak dan mencatat suasana hati mereka setiap hari. Aplikasi ini menyediakan cara mudah untuk merefleksikan keadaan emosional, dan memantau kesehatan mental dari waktu ke waktu.

## Fitur Utama

* **Pencatatan Mood:** Pengguna dapat dengan cepat memilih emoji yang mewakili suasana hati mereka hari ini.
* **Catatan Harian:** Opsi untuk menambahkan catatan atau jurnal singkat untuk setiap entri mood.
* **Riwayat Mood:** Menampilkan daftar semua entri mood yang telah dicatat, diurutkan berdasarkan tanggal dan waktu.
* **Autentikasi Pengguna:** Sistem login dan registrasi yang aman menggunakan email dan password.
* **Layar Sambutan:** Pengguna baru akan disambut dengan layar "Get Started" saat pertama kali membuka aplikasi.

## Teknologi yang Digunakan

* **Framework:** Flutter
* **Backend & Autentikasi:** Firebase (Authentication & Cloud Firestore)
* **Penyimpanan Lokal:** SharedPreferences (untuk menandai pengguna yang baru pertama kali membuka aplikasi)
* **Manajemen State:** Provider
* **Lainnya:**
    * `intl`: Untuk pemformatan tanggal dan waktu.

## Langkah Instalasi dan Build

1.  **Clone Repositori**

    ```bash
    git clone https://github.com/uass-ambw/mood_jurnal.git
    cd mood_jurnal
    ```

2.  **Install Dependencies**
    Pastikan Anda memiliki Flutter SDK yang terpasang. Jalankan perintah berikut di terminal:

    ```bash
    flutter pub get
    ```

3.  **Konfigurasi Firebase**
    Proyek ini sudah dikonfigurasi dengan file `google-services.json` untuk Android dan `GoogleService-Info.plist` untuk iOS (via `firebase_options.dart`).

4.  **Jalankan Aplikasi**
    ```bash
    flutter run
    ```

## Uji Coba Login

Aplikasi ini tidak menyediakan akun dummy secara default. Untuk melakukan uji coba, silakan **buat akun baru** melalui halaman "Sign Up". Anda dapat menggunakan email dan password apa pun selama memenuhi persyaratan validasi (email valid dan password minimal 6 karakter).
