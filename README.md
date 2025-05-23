# Dynamic MobSF Setup

Script ini memungkinkan siapa saja untuk melakukan instalasi dan setup lengkap Mobile Security Framework (MobSF), Android Emulator, dan Frida hanya dengan satu perintah shell. Cocok untuk analisis dinamis aplikasi Android.

## 📦 Fitur
- Instalasi otomatis MobSF, Android SDK, dan emulator
- Setup Frida server untuk hooking dan instrumentation
- Setup AVD (Android Virtual Device) dengan API 28
- Jalankan MobSF dan emulator dalam satu klik

## 📁 Struktur Instalasi
Semua file akan diinstal di direktori berikut:
```
/opt/dynamic-mobsf
```

## 🛠️ Cara Menggunakan
### 1. Clone Repository
```bash
git clone https://github.com/dword32bit/dynamic-mobsf.git
cd dynamic-mobsf
```

### 2. Jalankan Script Instalasi
```bash
sudo bash setup.sh
```

### 3. Jalankan MobSF + Emulator
```bash
bash /opt/dynamic-mobsf/run_mobsf.sh
```

### 4. Buka MobSF di Browser
```
http://127.0.0.1:8000
```

## ⚠️ Persyaratan
- OS: Linux (Debian/Ubuntu)
- Harus dijalankan sebagai root
- Koneksi internet

## 🧪 Analisis Dinamis
1. Upload APK ke MobSF
2. Klik tab "Dynamic Analyzer"
3. Jalankan MobSFy Runtime
4. Klik Launch App dan Start Instrumentation
5. Gunakan emulator untuk navigasi aplikasi
6. Lihat hasil hooking dan analisis di dashboard

## 🤝 Kontribusi
Pull request sangat diterima! Silakan buat issue untuk bug atau fitur baru.
