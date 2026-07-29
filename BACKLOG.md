# BACKLOG — SPR133 Baby Cry Analysis App

**Package:** SPR133 | **Project:** CT-PR-0190 Baby Cry Analysis System | **Last Updated:** 2026-07-30

Commit format: `SPR133-<NNN>: short description`

Status labels: `[ ]` Pending · `[~]` In Development · `[V]` In V&V · `[x]` Closed

---

## Active

| ID | Item | Status | Notes |
|----|------|--------|-------|

_(no active items)_

---

## Documentation

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-004 | Create Architecture document (Architecture_SPR133.md) | [ ] | Software Architecture |
| SPR133-005 | Create setup document (setup.md) | [ ] | Build and run instructions |
| SPR133-006 | Create software baseline (software-baseline.md) | [ ] | Development environment baseline |
| SPR133-007 | Create SOUP register (SOUP.md) | [ ] | Third-party software components |
| SPR133-009 | Perform final code review and issue fixes | [ ] | Pre-release verification |
| SPR133-010 | Prepare Version 1.0.2 Debug APK | [ ] | Debug build |

---

## Milestone 5 – Testing & Verification

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-060 | Perform functional testing | [ ] | Feature verification |
| SPR133-061 | Verify mandatory patient information validation | [ ] | Automatic validation |
| SPR133-062 | Verify automatic enable/disable behavior of Audio Recording and Upload Audio sections | [ ] | UI validation |
| SPR133-063 | Verify Data Upload workflow | [ ] | Upload API validation |
| SPR133-064 | Verify AI Prediction workflow | [ ] | AI API validation |
| SPR133-065 | Verify Upload History functionality | [ ] | Upload History verification |
| SPR133-066 | Verify individual and bulk delete operations | [ ] | History delete verification |
| SPR133-067 | Verify report generation, saving and sharing | [ ] | PDF verification |
| SPR133-068 | Perform regression testing | [ ] | Overall verification |
| SPR133-069 | Resolve identified issues | [ ] | Bug fixes |
| SPR133-070 | Prepare package for milestone review | [ ] | Ready for TL review |

---

## Closed

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-001 | Initialize repository structure | [x] | Standard repository structure created |
| SPR133-002 | Create and maintain project backlog (BACKLOG.md) | [x] | Initial backlog created |
| SPR133-003 | Create Software Requirements Specification (SRS_SPR133.md) | [x] | SRS created and revised to Version 1.0.2. |
| SPR133-008 | Update BACKLOG according to revised SRS | [x] | Revised milestones and tasks aligned with SRS v1.0.2 |

### Milestone 1 – Project Setup & Patient Information

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-011 | Create Baby Cry Analysis module structure | [x] | Module structure completed |
| SPR133-012 | Create Baby Cry Analysis screen UI | [x] | UI completed |
| SPR133-013 | Implement Patient Information form | [x] | Patient information form completed |
| SPR133-014 | Implement Age input (Day / Month / Year) | [x] | Completed |
| SPR133-015 | Implement Gender selection | [x] | Completed |
| SPR133-016 | Implement Actual Reason selection | [x] | Completed |
| SPR133-017 | Implement Notes field | [x] | Completed |
| SPR133-018 | Implement automatic mandatory field validation | [x] | Automatic validation implemented |
| SPR133-019 | Enable Audio Recording and Upload Audio sections after mandatory patient information is completed | [x] | Pending implementation as per revised SRS |
| SPR133-020 | Implement Reset functionality | [x] | Pending |
| SPR133-021 | Implement microphone permission handling | [x] | Permission flow completed |

### Milestone 2 – Audio Recording & Playback

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-022 | Implement baby cry audio recording | [x] | Recording completed |
| SPR133-023 | Implement Start and Stop recording controls | [x] | Completed |
| SPR133-024 | Save recorded audio locally | [x] | Local storage completed |
| SPR133-025 | Generate audio filename using [PID]_[DDMMYYYYHHMMSS].wav | [x] | Naming convention implemented |
| SPR133-026 | Store audio in App directory / Download folder | [x] | Completed |
| SPR133-027 | Implement recorded audio playback | [x] | Playback completed |
| SPR133-028 | Implement discard and re-record functionality | [x] | Completed |
| SPR133-029 | Enable recorded audio for Data Upload and AI Prediction workflows | [ ] | Pending implementation |

### Milestone 3 – Data Upload, AI Prediction & Upload History

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-030 | Implement existing WAV audio file selection | [x] | WAV selection completed |
| SPR133-031 | Validate supported audio format (.wav) | [x] | Validation completed |
| SPR133-032 | Implement multipart/form-data request structure | [x] | Multipart request structure implemented for Upload Data and AI Prediction APIs |
| SPR133-033 | Implement Upload Data API integration (/upload_media) | [x] | Upload Data API implemented |
| SPR133-034 | Display upload success message | [x] | Success message implemented |
| SPR133-035 | Clear patient information and audio after successful upload | [x] | Implemented |
| SPR133-036 | Implement Predict Now API integration (/analyze) | [x] | Predict Now API implemented |
| SPR133-037 | Display loading indicator during AI prediction | [x] | Completed |
| SPR133-038 | Handle successful AI prediction response | [x] | Completed |
| SPR133-039 | Handle API failures and network errors | [x] | Completed |
| SPR133-040 | Implement local Upload History storage | [ ] | Pending |
| SPR133-041 | Save Data Upload records into Upload History | [ ] | Pending |
| SPR133-042 | Save AI Prediction records into Upload History | [ ] | Pending |
| SPR133-043 | Store upload status (Success/Failed) | [ ] | Pending |
| SPR133-044 | Store patient details, audio filename and timestamp in Upload History | [ ] | Pending |

### Milestone 4 – Baby Cry Analysis Report & Upload History UI

| ID | Item | Status | Notes |
|----|------|--------|-------|
| SPR133-045 | Design Baby Cry Analysis Report screen | [x] | Report UI completed |
| SPR133-046 | Display patient demographic information | [x] | Completed |
| SPR133-047 | Display prediction label and confidence score | [x] | Completed |
| SPR133-048 | Display report timestamp | [x] | Completed |
| SPR133-049 | Generate PDF report | [x] | Completed |
| SPR133-050 | Save PDF using [PID]_[DDMMYYYYHHMMSS].pdf | [x] | Naming convention implemented |
| SPR133-051 | Store PDF in App directory / Download folder | [x] | Completed |
| SPR133-052 | Implement Share Report functionality | [x] | Completed |
| SPR133-053 | Design Upload History screen | [ ] | Pending |
| SPR133-054 | Display Upload History records | [ ] | Pending |
| SPR133-055 | Display upload status, patient information, timestamp and audio filename | [ ] | Pending |
| SPR133-056 | Display Prediction Label and Confidence Score for AI Prediction records | [ ] | Pending |
| SPR133-057 | Implement Delete individual Upload History record | [ ] | Pending |
| SPR133-058 | Implement Clear History functionality | [ ] | Pending |
| SPR133-059 | Display empty state when no Upload History is available | [ ] | Pending |
