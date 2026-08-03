# Software Baseline — SPR133 Baby Cry Analysis App

Package: SPR133 | Project: CT-PR-0190 Baby Cry Analysis System

---

## SPR133 v1.0.2 — Software Baseline

| Item | Version / Value | Notes |
|------|-----------------|-------|
| Software Version | v1.0.2 | Current development baseline |
| Module | Baby Cry Data Collection and AI Analysis | Main application module |
| Platform | Android | Flutter Mobile Application |
| Framework | Flutter 3.16.0 | Stable |
| Language | Dart 3.2.0 | |
| State Management | GetX | Reactive state management |
| Network Communication | REST API (HTTP Multipart Request) | Data Upload & AI Prediction |
| Data Upload API | `/upload_media` | Dataset collection |
| AI Prediction API | `/analyze` | AI-based baby cry prediction |
| Audio Format | WAV (.wav) | Supported audio format |
| Audio Recording | Flutter Audio Recorder | Local recording |
| Local Storage | Application Directory | Audio & PDF storage |
| Upload History Storage | SharedPreferences / Local Storage | Stores upload records locally |
| Report Generation | PDF | Baby Cry Analysis Report |
| Target Device | Android Mobile Device | Android 10.0 or above |
| Android SDK | Platform 36 | Build Tools 36.1.0 |
| Java | OpenJDK 11 | Development environment |
| Configuration Profile | Development | Current baseline |
| Third-Party Components | See SOUP.md | Dependency details |

---

## Test Environment

| Item | Value |
|------|-------|
| Operating System | Ubuntu 22.04.5 LTS |
| IDE | Android Studio 2022.1 |
| Flutter SDK | 3.16.0 |
| Dart SDK | 3.2.0 |
| Mobile Platform | Android |
| Test Device | Redmi 13C 5G |
| Android Version | Android 14 |
| Internet | Wi-Fi / Mobile Data |
| Audio Source | Device Microphone |

---

## Baseline Scope

Software Baseline v1.0.2 includes:

- Patient Information Management
- Baby Cry Audio Recording
- WAV Audio Selection
- Audio Playback
- Data Upload workflow
- AI Prediction workflow
- Upload History management
- Baby Cry Analysis Report generation
- PDF Save and Share functionality

---

## Related Documents

- SRS_SPR133.md
- Architecture_SPR133.md
- setup.md
- SOUP.md
- BACKLOG.md

---

**Prepared By:** Kumar Deepak

**Status:** Version 1.0.2 (Ready for Review)
