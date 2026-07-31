# Functional Test Report — SPR133 Baby Cry Analysis App

**Package ID & Name:** SPR133 Baby Cry Analysis App  
**Product Code & Name:** CT-PR-0190 Baby Cry Analysis System  
**Module:** Baby Cry Data Collection and AI Analysis  
**Version:** 1.0.2  

---

## 1. Purpose

This document records the functional verification results of the **SPR133 Baby Cry Analysis App**.

The objective is to verify that the implemented functionality complies with the Software Requirements Specification (SRS) and Architecture & Design Document (ADD).

---

## 2. Test Environment

| Item | Details |
|------|---------|
| Operating System | Ubuntu 22.04.5 LTS |
| Flutter SDK | 3.16.0 |
| Dart SDK | 3.2.0 |
| Android Studio | 2022.1 |
| Android Device | Redmi 13C 5G |
| Android Version | Android 14 |
| Mobile Platform | Android |
| Audio Source | Device Microphone |
| Network | Wi-Fi / Mobile Data |

---

## 3. Test Scope

The following functional areas were verified:

- Patient Information Management
- Mandatory Field Validation
- Audio Recording
- Audio Playback
- Data Upload
- AI Prediction
- Upload History
- Report Generation
- PDF Save & Share
- Error Handling
- Local Storage

---

## 4. Functional Test Cases

| Test ID | Requirement Reference | Feature | Test Procedure | Expected Result | Actual Result | Status |
|---------|----------------------|---------|----------------|-----------------|---------------|--------|
| TC-001 | FR-01 | Patient Information | Enter mandatory patient details | Mandatory fields accepted successfully | As Expected | Pass |
| TC-002 | FR-02 | Mandatory Validation | Leave mandatory fields empty | Record, Upload and Predict buttons remain disabled | As Expected | Pass |
| TC-003 | FR-03 | Audio Recording | Record baby cry audio | Audio recorded and stored locally | As Expected | Pass |
| TC-004 | FR-04 | Audio Playback | Play recorded audio | Audio playback successful | As Expected | Pass |
| TC-005 | FR-05 | Upload Data API | Upload patient information and audio | Upload completed successfully | As Expected | Pass |
| TC-006 | FR-06 | AI Prediction API | Execute AI Prediction | Prediction and confidence score displayed | As Expected | Pass |
| TC-007 | FR-07 | Upload History | Perform Upload Data and AI Prediction | Records stored successfully in Upload History | As Expected | Pass |
| TC-008 | FR-08 | Upload History Status | Verify upload status | Success/Failed status displayed correctly | As Expected | Pass |
| TC-009 | FR-09 | Delete Upload History Record | Delete a single record | Selected record removed successfully | As Expected | Pass |
| TC-010 | FR-10 | Clear Upload History | Clear all history | All records removed after confirmation | As Expected | Pass |
| TC-011 | FR-11 | Report Generation | Generate Baby Cry Analysis Report | PDF generated successfully | As Expected | Pass |
| TC-012 | FR-12 | Share Report | Share generated PDF | Android share sheet opened successfully | As Expected | Pass |
| TC-013 | FR-13 | API Failure Handling | Disconnect network and perform Upload/Predict | Proper error message displayed and failure recorded | As Expected | Pass |
| TC-014 | NFR-01 | Performance | Execute Upload and Prediction workflows | Application remains responsive during processing | As Expected | Pass |
| TC-015 | NFR-02 | Local Storage | Verify saved audio, PDF and Upload History | Files and history stored correctly | As Expected | Pass |

---

## 5. Requirement Traceability Matrix

| SRS Requirement | Test Case(s) |
|-----------------|--------------|
| FR-01 Patient Information | TC-001 |
| FR-02 Mandatory Validation | TC-002 |
| FR-03 Audio Recording | TC-003 |
| FR-04 Audio Playback | TC-004 |
| FR-05 Data Upload | TC-005 |
| FR-06 AI Prediction | TC-006 |
| FR-07 Upload History | TC-007, TC-008, TC-009, TC-010 |
| FR-08 Report Generation & Share | TC-011, TC-012 |
| FR-09 Error Handling | TC-013 |
| NFR-01 Performance | TC-014 |
| NFR-02 Local Storage | TC-015 |

---

## 6. Test Summary

| Item | Count |
|------|------:|
| Total Test Cases | 15 |
| Passed | 15 |
| Failed | 0 |
| Blocked | 0 |
| Not Executed | 0 |

---

## 7. Defects Observed

No functional defects were identified during testing.

---

## 8. Conclusion

The **SPR133 Baby Cry Analysis App** has been functionally verified against the requirements defined in the Software Requirements Specification (SRS) and Architecture & Design Document (ADD).

All planned functional test cases passed successfully. The application correctly performs patient information validation, baby cry audio recording, Data Upload, AI Prediction, Upload History management, report generation, PDF sharing, and local data storage.

The application is considered ready for package review and integration after completion of the remaining documentation and verification activities.

---

## 9. Approval

| Role | Name | Date |
|------|------|------|
| Prepared By | Kumar Deepak | 2026-07-31 |
| Reviewed By | | |
| Approved By | | |
