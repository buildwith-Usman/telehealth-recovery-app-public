# Recovery Consultation Mobile App

A complete telehealth solution designed for **recovery and rehabilitation services**, enabling seamless **doctor-patient interaction** through a fully integrated mobile platform.

---

## 🚀 Overview

The **Recovery Consultation Mobile App** allows patients to **book consultations**, **attend online video sessions**, **order medicines**, and manage their health records. It also provides doctors with tools for managing consultations, tracking earnings, and maintaining session notes. An **admin panel** is included for managing users, sessions, and payments.

---

## ✅ Key Features

### **👤 Patient Features**

- **Secure Authentication** – Login & Sign Up
- **Specialist Directory** – Browse and find doctors
- **Consultation Booking** – Schedule sessions with specialists
- **Online Video Sessions** – Secure and real-time video consultations
- **Payment Gateway** – Multiple payment options & payment history
- **Medicine Ordering (Pharmacy)** – Order medicines and track delivery
- **Profile & Account Settings** – Update personal details
- **Session Notes & History** – View consultation details
- **Doctor Reviews** – Rate and review doctors

### **🩺 Doctor Features**

- **Profile Management** – Manage professional details
- **Session Management** – View, reschedule, and manage sessions
- **Withdrawal Methods & History** – Track and withdraw earnings
- **Patient Directory** – View patient details & history
- **Session Notes** – Maintain patient records securely

### **🛠 Admin Features**

- **Doctor & Patient Management** – Add, approve/disapprove, or edit profiles
- **Session Control** – Monitor, approve, or reschedule sessions
- **Payment Tracking** – Full transaction and withdrawal history
- **Medicine Orders Management** – Track and manage pharmacy orders
- **Review & Notes Oversight** – Access and manage feedback and notes

---

## 🛒 Additional Features

- **Pharmacy Integration** – Order and track medicines online
- **Automated Notifications** – Reminders for sessions and medicine delivery
- **Multi-role Login** – Patients, Doctors, and Admin

---

## 🏗 Tech Stack

- **Frontend:** Flutter (Cross-platform for Android & iOS)
- **Authentication:** JWT-based Secure Login
- **Video Consultation:** WebRTC or Third-party SDK (Agora)
- **Payment Gateway:** Stripe / JazzCash / Easypaisa
- **Push Notifications:** Firebase Cloud Messaging (FCM)

---

## 📂 Folder Structure

```

recovery-consultation-mobile-app/
├── lib/                 # Flutter app source code
├── assets/              # Images, icons, fonts
├── android/             # Android-specific files
├── ios/                 # iOS-specific files
└── README.md            # Project documentation

```

---

## ⚙️ Installation Guide

1. **Clone the repository**
   ```bash
   git clone https://github.com/buildwith-Usman/recovery-consultation-mobile-app.git
   ```

2. **Navigate to the project directory**
   ```bash
   cd recovery-consultation-mobile-app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 🛠 Development Commands

### **Code Generation Commands**

**Generate all .g.dart files (JSON serialization, Retrofit APIs, etc.)**
```bash
dart run build_runner build --delete-conflicting-outputs
```

**Watch for changes and auto-generate**
```bash
dart run build_runner watch --delete-conflicting-outputs
```

flutter pub run build_runner build --delete-conflicting-outputs

**Clean generated files**
```bash
dart run build_runner clean
```

### **Locale Generation Commands**

**Generate locale files using gen.sh script**
```bash
chmod +x gen.sh && ./gen.sh
```

**Alternative locale generation**
```bash
get generate locales assets/locales
```

### **Flutter Commands**

**Run app in debug mode**
```bash
flutter run
```

**Build APK for Android**
```bash
flutter build apk --release
```

**Build App Bundle for Android**
```bash
flutter build appbundle --release
```

**Build iOS (requires macOS)**
```bash
flutter build ios --release
```

**Analyze code quality**
```bash
flutter analyze
```

**Run tests**
```bash
flutter test
```

**Clean build cache**
```bash
flutter clean && flutter pub get
```

### **Project Structure Commands**

**View dependency tree**
```bash
flutter pub deps
```

**Check for outdated packages**
```bash
flutter pub outdated
```

**Upgrade dependencies**
```bash
flutter pub upgrade
```

---

## 📁 Key Files & Folders

```
recovery-consultation-mobile-app/
├── lib/
│   ├── app/                    # Core app configuration
│   │   ├── config/            # App constants, colors, routes
│   │   ├── controllers/       # Base controllers (GetX)
│   │   ├── services/          # Core services
│   │   └── utils/             # Utility classes
│   ├── data/                  # Data layer
│   │   ├── api/               # API requests & responses
│   │   ├── datasource/        # Data sources
│   │   └── mapper/            # Data mapping
│   ├── domain/                # Domain layer
│   │   ├── entity/            # Domain entities
│   │   ├── repository/        # Repository interfaces
│   │   └── usecase/           # Business logic
│   ├── presentation/          # UI layer
│   │   ├── widgets/           # Reusable widgets
│   │   └── [screens]/         # Feature screens
│   └── generated/             # Generated files (locales, assets)
├── assets/
│   ├── locales/               # Translation files
│   ├── icons/                 # SVG icons
│   ├── images/                # Images
│   └── fonts/                 # Custom fonts
├── gen.sh                     # Locale generation script
└── pubspec.yaml              # Dependencies & configuration
```

---

## 📌 Future Enhancements

* AI-powered health recommendations
* Multi-language support
* Integration with wearable devices

---

## 📬 Contact

**Author:** Muhammad Usman
**Email:** buildwithusman@gmail.com

---
````
