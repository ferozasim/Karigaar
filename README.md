# Karigaar — On-Demand Skilled Artisan & Home Services Platform

> **Archetype:** *"Master Guildsman Meets Modern Concierge"*  
> **Pilot City:** **Nanded, Maharashtra** (Hyperlocal pilot corridor)  
> **Firebase Project:** `karigaar-ba812`  
> **Target Platforms:** Cross-Platform Mobile App (Flutter for iOS & Android with unified Customer & Artisan modes) + Super Admin Operations Web Portal (Next.js 14).

---

## 1. Project Directory Structure

```text
Karigaar_app/
├── apps/
│   ├── mobile_app/                  # Flutter Mobile App (iOS & Android)
│   │   ├── assets/                  # Reference UI screens, brand images, data JSONs
│   │   ├── lib/
│   │   │   ├── main.dart            # Main entrypoint with Riverpod & GoRouter
│   │   │   ├── core/                # Theme, Design Tokens, Routing, Config & Models
│   │   │   └── features/
│   │   │       ├── auth/            # WhatsApp Login & 6-digit OTP modal
│   │   │       ├── customer/        # Discovery (10 trades), Scoping, Live Map Tracking
│   │   │       ├── artisan/         # 45s Job Radar, Stopwatch & Dynamic Bill Builder
│   │   │       └── shared/          # Unified Customer & Artisan Mode Switcher Pill
│   │   ├── test/                    # Unit & Widget tests
│   │   └── pubspec.yaml             # Mobile dependencies & assets declarations
│   └── admin_web/                   # Super Admin Portal (Next.js 14 / React 18)
│       ├── src/app/                 # HQ Live Ops Stream, Bento KPIs, Surge Grid
│       └── package.json             # Web dependencies
├── config/                          # Data-Driven Master Configurations
│   ├── pilot_city_nanded.json       # Nanded coordinates, 10 localities & pincodes
│   ├── launch_trades.json           # 10 launch trades, Marathi names & pricing models
│   └── design_tokens.json           # Design tokens extracted from DESIGN.md
├── scripts/                         # Automated Tooling & SDK Installers
│   ├── setup-workspace.bat          # One-click Windows CMD/PowerShell setup launcher
│   ├── setup-environment.ps1        # Master SDK orchestrator (Flutter, Android, Java, Studio)
│   ├── install-flutter.ps1          # Automated Flutter SDK installer (User PATH)
│   ├── install-android-sdk.ps1      # Automated Android command-line tools installer
│   ├── install-android-studio.ps1   # Automated Android Studio IDE installer (User level)
│   ├── install-java.ps1             # Portable OpenJDK 17 LTS installer
│   └── verify-env.ps1               # Environment health-check diagnostic script
├── tests/
│   └── test-foundation.js           # Automated deep foundation verification test suite
├── firebase.json                    # Firebase hosting, rules, and emulators config
├── firestore.rules                  # Hardened Cloud Firestore security rules
├── firestore.indexes.json           # Composite indexes for radar & artisan queries
├── storage.rules                    # Cloud Storage security rules for KYC & audio
└── .firebaserc                      # Firebase project binding (karigaar-ba812)
```

---

## 2. Pilot City: Nanded, Maharashtra

Karigaar is configured with a fully data-driven city architecture centered on **Nanded-Waghala, Maharashtra**:
- **Center Coordinates:** `19.1383° N, 77.3210° E`
- **Pincodes Covered:** `431601`, `431602`, `431603`, `431604`, `431605`
- **Default Dispatch Radius:** `4.5 km`
- **Emergency Dispatch Window:** `25 minutes guaranteed arrival`
- **10 Core Localities & Hubs:**
  1. Anand Nagar (`loc_anand_nagar` - High Residential Emergency Hub)
  2. Vazirabad & Sarafa (`loc_vazirabad` - Commercial & Residential Hub)
  3. Taroda Naka & Taroda BK (`loc_taroda_naka` - Expansion Corridor)
  4. Shivaji Nagar (`loc_shivaji_nagar` - High Density)
  5. CIDCO New Nanded (`loc_cidco` - Planned Township)
  6. Workshop Corner & Khadgaon (`loc_workshop_corner`)
  7. Baba Nagar & Hyder Bagh (`loc_baba_nagar`)
  8. Snehnagar & Bhagya Nagar (`loc_snehnagar` - Premium Residential)
  9. Vishnupuri & SRTMUN Campus (`loc_vishnupuri`)
  10. Railway Station & Degloor Naka (`loc_station_degloor`)

---

## 3. The 10 Launch Trades & Guild Protections

All 10 trades feature bilingual English/Marathi naming, diagnostic visit fee structures, and the Karigaar Trust Shield:

| # | Trade Craft | Marathi Name | Diagnostic Fee | Safety Shield | Guarantee | Emergency 25m |
|---|:---|:---|:---:|:---:|:---:|:---:|
| 1 | **Electrician** | इलेक्ट्रिशियन | ₹199 | ₹29 | 30 Days | ✅ Yes |
| 2 | **Plumber** | प्लंबर (नळ कारागीर) | ₹199 | ₹29 | 30 Days | ✅ Yes |
| 3 | **Carpenter** | सुतार (कारपेंटर) | ₹249 | ₹29 | 30 Days | ✅ Yes |
| 4 | **Mason / Civil Worker** | गवंडी / सिव्हिल कामगार | ₹299 | ₹29 | 30 Days | ❌ No |
| 5 | **Painter** | रंगारी (पेंटर) | ₹199 | ₹29 | 30 Days | ❌ No |
| 6 | **AC & Refrigeration** | एसी आणि फ्रीज मेकॅनिक | ₹249 | ₹29 | 30 Days | ✅ Yes |
| 7 | **Appliance Repair** | घरगुती उपकरणे दुरुस्ती | ₹199 | ₹29 | 30 Days | ✅ Yes |
| 8 | **Welder / Fabricator** | वेल्डर / लोहार कामगार | ₹299 | ₹29 | 30 Days | ✅ Yes |
| 9 | **Pest Control** | कीटक नियंत्रण (पेस्ट कंट्रोल) | ₹249 | ₹29 | 60 Days | ❌ No |
| 10 | **Deep Cleaning** | डीप क्लीनिंग (स्वच्छता सेवा) | ₹199 | ₹29 | 30 Days | ❌ No |

---

## 4. Environment Setup & SDK Installation

### Automated One-Click Installation (Windows)
Double-click `scripts\setup-workspace.bat` or run:
```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-environment.ps1
```

This automated script performs the following actions **without requiring administrative privileges**:
1. Checks Node.js, npm, Git, and Docker.
2. Installs `firebase-tools` CLI globally via npm.
3. Downloads & installs portable **OpenJDK 17 LTS** into `%USERPROFILE%\development\jdk-17`, sets `JAVA_HOME`, and updates User PATH.
4. Clones and configures **Flutter SDK** stable branch into `%USERPROFILE%\development\flutter`, sets User PATH, and runs `flutter doctor`.
5. Downloads **Android Command-line Tools** into `%LOCALAPPDATA%\Android\Sdk`, configures `ANDROID_HOME`, accepts licenses, and installs API 34 platform & build tools.
6. Downloads portable **Android Studio IDE** into `%USERPROFILE%\development\android-studio`, registers it with Flutter (`flutter config --android-studio-dir`), sets user PATH, and generates Start Menu & Desktop shortcuts.
7. Runs a non-destructive verification check via `scripts\verify-env.ps1`.

### Diagnosing Your Environment
To verify current SDK availability anytime:
```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\verify-env.ps1
```

### Running Foundation Tests
```bash
node tests/test-foundation.js
```

---

## 5. Running the Applications

### Mobile App (Flutter)
```bash
cd apps/mobile_app
flutter pub get
flutter run
```

### Super Admin Web Portal (Next.js)
```bash
cd apps/admin_web
npm install
npm run dev
# Open http://localhost:3000
```
