# Setup — SPR133 Baby Cry Analysis App

Package: SPR133 | Project: CT-PR-0190 Baby Cry Analysis System | Version: 1.0.2 | Status: Development

---

## 1. Overview

This document describes the development environment, project setup, build process, and execution steps required to build and run the **SPR133 Baby Cry Analysis App**.

The application supports the following features:

- Patient Information Management
- Baby Cry Audio Recording
- Data Upload
- AI Prediction
- PDF Report Generation
- History Management

---

## 2. Prerequisites

### Development Environment

| Component | Version |
|----------|---------|
| Operating System | Ubuntu 22.04.5 LTS |
| Flutter SDK | 3.16.0 (Stable) |
| Dart SDK | 3.2.0 |
| Android Studio | 2022.1 |
| Android SDK | Platform 36 (Build Tools 36.1.0) |
| Java | OpenJDK 11 |
| Git | Latest Stable Release |

### Hardware Required

- Android Mobile Device
- Device Microphone
- Speaker / Earphones (for playback testing)
- Internet Connectivity

---

## 3. Source Code Repository

Repository Structure:

```text
SPR-133-BabyCryAnalysisApp/
├── _sandbox/
├── config/
├── docs/
│   ├── SRS_SPR133.md
│   ├── Architecture_SPR133.md
│   ├── BACKLOG.md
│   ├── setup.md
│   ├── software-baseline.md
│   └── SOUP.md
├── misc/
├── src/
├── tests/
├── tools/
├── .gitignore
├── BACKLOG.md
└── GETTING-STARTED-SPR.md
```

---

## 4. Install

Clone the repository.

```bash
git clone <repository-url>
```

Move into the project directory.

```bash
SPR-133-BabyCryAnalysisApp/
```

Checkout the development branch.

```bash
git checkout dev
```

Install project dependencies.

```bash
flutter pub get
```

---

## 5. Verify Flutter Installation

Verify that the Flutter environment is configured correctly.

```bash
flutter doctor
```

Resolve all reported issues before continuing.

---

## 6. Configure API

Configure the backend server URL before running the application.

Example:

```text
Base URL:
http://<server-address>
```

Supported Backend APIs:

- POST `/upload_media`
- POST `/analyze`

---

## 7. Required Android Permissions

The application requires the following Android permissions.

- INTERNET
- ACCESS_NETWORK_STATE
- RECORD_AUDIO
- READ_MEDIA_AUDIO (Android 13 and above)
- READ_EXTERNAL_STORAGE (Android 12 and below, if applicable)

---

## 8. Run the Application

Connect an Android device.

Verify connected devices.

```bash
flutter devices
```

Run the application.

```bash
flutter run
```

---

## 9. Build APK

### Debug APK

```bash
flutter build apk --debug
```

Generated APK

```
build/app/outputs/flutter-apk/app-debug.apk
```

### Release APK

```bash
flutter build apk --release
```

Generated APK:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## 10. Test Suite

Run the Flutter test suite.

```bash
flutter test
```

---

## 11. Troubleshooting

### Flutter packages not installed

```bash
flutter clean
flutter pub get
```

### Gradle issues

```bash
flutter clean
flutter pub get
flutter run
```

### Device not detected

```bash
adb devices
```

Reconnect the device and ensure **USB Debugging** is enabled.

### API connection failed

- Verify the configured Base URL.
- Check internet connectivity.
- Ensure backend services are running.
- Verify API endpoints are accessible.

---

## 12. Known Issues

No known issues at the time of this release.

---

## 13. Related Documents

- SRS_SPR133.md
- Architecture_SPR133.md
- software-baseline.md
- SOUP.md
- BACKLOG.md

---

## 14. Notes

- Use the **dev** branch for all development activities.
- Follow **BACKLOG.md** for implementation status and milestone tracking.
- Commit messages shall follow the format:

```text
SPR133-<NNN>: short description
```
