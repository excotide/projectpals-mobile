# projectpals_mobile

Aplikasi mobile berbasis Flutter untuk ProjectPals.

## Cara Instalasi

### 1. Prasyarat

Pastikan perangkat sudah terpasang:

- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Git](https://git-scm.com/downloads)
- Android Studio (untuk emulator dan Android SDK)
- VS Code atau Android Studio (IDE)

Opsional sesuai target platform:

- Xcode (jika ingin build iOS/macOS, khusus macOS)
- Visual Studio dengan workload C++ (jika ingin build Windows desktop)

### 2. Clone Repository

```bash
git clone <url-repository-anda>
cd projectpals_mobile
```

Jika repository sudah ada di lokal, langsung masuk ke folder project:

```bash
cd projectpals_mobile
```

### 3. Cek Environment Flutter

```bash
flutter doctor
```

Selesaikan semua issue penting yang ditandai oleh `flutter doctor` sebelum lanjut.

### 4. Install Dependency

```bash
flutter pub get
```

### 5. Jalankan Aplikasi

Pastikan emulator aktif atau device fisik sudah terhubung, lalu jalankan:

```bash
flutter run
```

Jika ingin memilih device tertentu:

```bash
flutter devices
flutter run -d <device_id>
```

## Build Release (Opsional)

Android APK:

```bash
flutter build apk --release
```

Android App Bundle (Play Store):

```bash
flutter build appbundle --release
```

## Perintah Berguna

```bash
flutter clean
flutter pub get
flutter test
```
