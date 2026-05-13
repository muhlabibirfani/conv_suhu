# 🔐 Panduan Setup Firebase & Login

## ✅ Yang Sudah Ditambahkan

### 1. **Dependencies** (pubspec.yaml)
- `firebase_core` - Core Firebase SDK
- `firebase_auth` - Authentication
- `google_sign_in` - Login dengan Google

### 2. **File Baru yang Dibuat**
- `lib/providers/auth_provider.dart` - State management untuk auth
- `lib/screens/login_screen.dart` - UI login & register
- `lib/screens/auth_wrapper.dart` - Routing based on auth status
- `lib/firebase_options.dart` - Konfigurasi Firebase (template)

### 3. **Fitur Yang Tersedia**
✅ Login dengan Email & Password
✅ Register akun baru
✅ Login dengan Google
✅ Forgot Password
✅ Logout
✅ Profil pengguna

---

## 🚀 Langkah Setup (WAJIB DILAKUKAN)

### **Langkah 1: Setup Firebase Project**

1. Buka https://console.firebase.google.com/
2. Klik **Create a new project** atau gunakan project yang sudah ada
3. Pilih nama project (misal: `konf_suhu_provider`)
4. Lanjutkan setup hingga selesai

### **Langkah 2: Install Firebase CLI**

```bash
npm install -g firebase-tools
```

### **Langkah 3: Setup Dengan FlutterFire**

1. Masuk ke folder project:
```bash
cd c:\Cinematic_MC\konf_suhu_provider
```

2. Jalankan flutterfire configure:
```bash
flutterfire configure
```

3. Pilih project Firebase yang telah dibuat
4. Pilih platform yang ingin didukung (android, ios, web, macos, windows, linux)
5. **PENTING**: Sistem akan auto-generate file `lib/firebase_options.dart` dengan konfigurasi benar

### **Langkah 4: Setup Firebase Authentication**

Di Firebase Console:
1. Pilih project Anda
2. Buka **Authentication** (di sidebar kiri)
3. Klik **Get Started**
4. Di tab **Sign-in method**, enable:
   - ✅ **Email/Password** - untuk login email
   - ✅ **Google** - untuk login Google

### **Langkah 5: Setup Google Sign-In (untuk platform yang dipilih)**

#### **Untuk Android:**
1. Buka https://console.firebase.google.com/
2. Project Settings → (nama project)
3. Tab **Cloud Messaging**
4. Copy **Sender ID** dari **Server API Key**
5. Di Android Studio, generate SHA-1:
   ```bash
   cd android
   ./gradlew signingReport
   ```
6. Copy SHA-1, paste ke Firebase Console (Project Settings → App signing certificate SHA-1)

#### **Untuk iOS:**
1. Di Firebase Console, pilih iOS app
2. Download GoogleService-Info.plist
3. Drag ke Xcode Runner project

#### **Untuk Web:**
1. Firebase Console sudah generate konfigurasi otomatis

---

## 📥 Install Dependencies

```bash
cd c:\Cinematic_MC\konf_suhu_provider
flutter pub get
```

---

## 🎨 Asset untuk Google Logo

Buat folder `assets/` di root project (jika belum ada):

```
assets/
└── google_logo.png
```

Download Google logo dari: https://www.gstatic.com/firebaseui/v0.5.2/images/google.svg

atau gunakan command:
```bash
mkdir assets
cd assets
# Download atau copy file google_logo.png
```

Update `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/google_logo.png
```

---

## 🧪 Testing

1. **Install APK/app ke device/emulator:**
```bash
flutter run
```

2. **Coba fitur:**
   - ✅ Register akun baru dengan email
   - ✅ Login dengan email & password
   - ✅ Login dengan Google
   - ✅ Forgot password
   - ✅ Logout
   - ✅ Lihat profile pengguna

---

## 📱 Struktur Layar

```
┌─────────────────┐
│  LOGIN/REGISTER │ ← User belum login
│  - Email field  │
│  - Password     │
│  - Google btn   │
│  - Forgot pwd   │
└────────┬────────┘
         │ After login
         ▼
┌─────────────────────┐
│  CONVERTER SCREEN   │ ← User sudah login
│  - Temp converter   │
│  - User profile btn │
│  - Logout option    │
└─────────────────────┘
```

---

## 🔧 Troubleshooting

### **Error: "firebase_core not initialized"**
→ Pastikan `Firebase.initializeApp()` di main.dart dipanggil sebelum `runApp()`

### **Error: "Google sign-in failed"**
→ Pastikan sudah setup Google OAuth di Firebase Console
→ Pastikan SHA-1 sudah di-register untuk Android

### **Asset google_logo.png tidak ditemukan**
→ Create folder `assets/` dan download google logo
→ Update `pubspec.yaml` dengan `assets:` section

### **Error compilation di Android**
→ Update `android/build.gradle` dengan Firebase dependencies terbaru

---

## 📚 Resources

- [Firebase Documentation](https://firebase.flutter.dev/)
- [Flutter Firebase Setup](https://firebase.google.com/docs/flutter/setup)
- [Firebase Authentication](https://firebase.flutter.dev/docs/auth/overview)

---

## 💾 Struktur File

```
lib/
├── main.dart                          ← Updated: Firebase init
├── firebase_options.dart              ← NEW: Firebase config
├── providers/
│   ├── auth_provider.dart            ← NEW: Auth state
│   └── temperature_provider.dart      ← Existing
├── screens/
│   ├── login_screen.dart             ← NEW: Login/Register UI
│   ├── auth_wrapper.dart             ← NEW: Auth routing
│   └── converter_screen.dart          ← Existing
└── ...
```

---

**Happy Coding! 🚀**
