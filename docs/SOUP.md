# SOUP Register — SPR133 Baby Cry Analysis App

Package: SPR133 | Project: CT-PR-0190 Baby Cry Analysis System | IEC 62304

---

## Software of Unknown Provenance (SOUP)

The following third-party software components are used within the SPR133 Baby Cry Analysis App. All dependency versions are fixed and verified for the current software baseline (v1.0.2).

| SOUP Item | Version | Supplier | Purpose | Anomaly List Available? |
|-----------|---------|----------|---------|-------------------------|
| Flutter SDK | 3.16.0 | Google LLC | Cross-platform application framework | Yes |
| Dart SDK | 3.2.0 | Google LLC | Programming language | Yes |
| GetX (`get`) | 4.6.6 | GetX Community | State management, dependency injection and route management | Yes |
| Record (`record`) | 5.0.5 | Flutter Community | Audio recording from device microphone | Yes |
| AudioPlayers (`audioplayers`) | 5.2.1 | Blue Fire Team | Audio playback for recorded and selected WAV files | Yes |
| Path Provider (`path_provider`) | 2.1.4 | Flutter Community | Access application storage directories | Yes |
| Permission Handler (`permission_handler`) | 11.3.1 | Baseflow | Runtime permission management | Yes |
| File Picker (`file_picker`) | 8.0.0 | Flutter Community | Select existing WAV audio files | Yes |
| HTTP (`http`) | 1.2.0 | Dart Team (Google LLC) | REST API communication using multipart requests | Yes |
| PDF (`pdf`) | 3.11.2 | DavBfr | Generate Baby Cry Analysis PDF reports | Yes |
| Printing (`printing`) | 5.12.0 | DavBfr | Print and export generated PDF reports | Yes |
| Intl (`intl`) | 0.19.0 | Dart Team (Google LLC) | Date, time and localization support | Yes |
| Share Plus (`share_plus`) | 7.2.2 | Flutter Community | Share generated PDF reports | Yes |
| Get Storage (`get_storage`) | 2.1.1 | GetX Community | Local storage for Upload History and application data | Yes |
| Google Fonts (`google_fonts`) | 5.0.0 | Google LLC | Google Fonts integration | Yes |
| Lottie (`lottie`) | 3.1.3 | Lottie Community | Animation rendering | Yes |
| Flutter Launcher Icons (`flutter_launcher_icons`) | 0.13.1 | Flutter Community | Generate Android application launcher icons | Yes |

---

## SOUP Assessment

- All third-party libraries are obtained from trusted public repositories (pub.dev).
- Dependency versions are fixed and maintained through `pubspec.yaml`.
- Third-party software shall be reviewed before upgrading to newer versions.
- Reported defects, security advisories, and compatibility issues shall be evaluated before adoption.
- Regression testing shall be performed after any dependency update.
- Only validated dependency versions shall be included in production releases.

---

## Related Documents

- SRS_SPR133.md
- Architecture_SPR133.md
- software-baseline.md
- setup.md
- BACKLOG.md

---

**Prepared By:** Kumar Deepak

**Status:** Version 1.0.2 (Ready for Review)
