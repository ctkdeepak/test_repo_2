# BACKLOG — SPR133 Baby Cry Analysis App

**Package:** SPR133 | **Project:** CT-PR-0190 Baby Cry Analysis System | **Last Updated:** 2026-07-14

Commit format: `SPR133-<NNN>: short description`

Status labels: `[ ]` Pending · `[~]` In Development · `[V]` In V&V · `[x]` Closed

---

## Active

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-007 | Create Baby Cry Analysis module structure | [~] | Initial Flutter module setup |

---

## Documentation

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-001 | Create and maintain project backlog (BACKLOG.md) | [ ] | Initial package backlog |
| SPR133-002 | Create Software Requirements Specification (SRS_SPR133.md) | [ ] | Software Requirements Specification |
| SPR133-003 | Create Architecture document (Architecture_SPR133.md) | [ ] | Software Architecture |
| SPR133-004 | Create setup document (setup.md) | [ ] | Build and run instructions |
| SPR133-005 | Create software baseline (software-baseline.md) | [ ] | Development environment baseline |
| SPR133-006 | Create SOUP register (SOUP.md) | [ ] | Third-party software components |

---

## Milestone 1 – Project Setup & Patient Information

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-007 | Create Baby Cry Analysis module structure | [ ] | Initial Flutter module setup |
| SPR133-008 | Create Baby Cry Analysis screen UI | [ ] | Main analysis screen |
| SPR133-009 | Implement Patient Information form | [ ] | Patient details entry |
| SPR133-010 | Implement Age input (Day / Month / Year) | [ ] | Numeric validation |
| SPR133-011 | Implement Gender selection | [ ] | Male / Female |
| SPR133-012 | Implement Actual Reason selection | [ ] | Dropdown values as per SRS |
| SPR133-013 | Implement Notes field | [ ] | Optional notes |
| SPR133-014 | Implement mandatory field validation | [ ] | Validate required inputs |
| SPR133-015 | Implement microphone permission handling | [ ] | Runtime permission |

---

## Milestone 2 – Audio Recording & Playback

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-016 | Implement baby cry audio recording | [ ] | WAV recording |
| SPR133-017 | Implement Start and Stop recording controls | [ ] | Recording workflow |
| SPR133-018 | Save recorded audio locally | [ ] | Local storage |
| SPR133-019 | Generate audio filename | [ ] | `[PID]_[DDMMYYYYHHMMSS].wav` |
| SPR133-020 | Store audio in App directory / Download folder | [ ] | As supported |
| SPR133-021 | Implement recorded audio playback | [ ] | Play / Pause |
| SPR133-022 | Implement Predict Now workflow | [ ] | Enable after recording |
| SPR133-023 | Implement discard and re-record functionality | [ ] | Record again |

---

## Milestone 3 – Audio Upload & AI Prediction

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-024 | Implement existing WAV audio file selection | [ ] | File picker |
| SPR133-025 | Validate supported audio format (.wav) | [ ] | Format validation |
| SPR133-026 | Implement multipart/form-data API request | [ ] | REST API |
| SPR133-027 | Upload patient information with audio | [ ] | Multipart request |
| SPR133-028 | Display loading indicator | [ ] | During prediction |
| SPR133-029 | Handle successful prediction response | [ ] | Prediction result |
| SPR133-030 | Handle API failures and network errors | [ ] | Error handling |

---

## Milestone 4 – Baby Cry Analysis Report

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-031 | Design Baby Cry Analysis Report screen | [ ] | Report UI |
| SPR133-032 | Display patient demographic information | [ ] | Patient details |
| SPR133-033 | Display prediction label and confidence score | [ ] | AI output |
| SPR133-034 | Display report timestamp | [ ] | Report generation time |
| SPR133-035 | Generate PDF report | [ ] | PDF generation |
| SPR133-036 | Save PDF using naming convention | [ ] | `[PID]_[DDMMYYYYHHMMSS].pdf` |
| SPR133-037 | Store PDF in App directory / Download folder | [ ] | Local storage |
| SPR133-038 | Implement Share Report functionality | [ ] | Native sharing |

---

## Milestone 5 – Testing & Verification

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-039 | Perform functional testing | [ ] | Feature verification |
| SPR133-040 | Verify patient information validation | [ ] | Mandatory fields |
| SPR133-041 | Verify recording, playback and upload workflow | [ ] | End-to-end testing |
| SPR133-042 | Verify AI prediction workflow | [ ] | API validation |
| SPR133-043 | Verify report generation, saving and sharing | [ ] | PDF verification |
| SPR133-044 | Perform regression testing | [ ] | Overall verification |
| SPR133-045 | Resolve identified issues | [ ] | Bug fixes |
| SPR133-046 | Prepare package for milestone review | [ ] | Ready for TL review |

---

## Closed

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-001 | Create and maintain project backlog (BACKLOG.md) | [x] | Initial BACKLOG.md created |
| SPR133-002 | Create Software Requirements Specification (SRS_SPR133.md) | [x] | SRS document completed |

