class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://172.16.75.23:8008';
  static const String uploadEndpoint = '/upload_media';
  static const String analyzeEndpoint = '/analyze';

  // Audio Configuration
  static const int maxRecordingDuration = 900; // 15 minutes in seconds
  static const String audioFormat = '.wav';

  // Gender Options
  static const List<String> genderOptions = ['Male', 'Female'];

  // Actual Reason Options
  static const List<String> actualReasonOptions = [
    'Unknown/Test',
    'Belly Pain',
    'Burping',
    'Discomfort',
    'Hungry',
    'Not a Cry',
    'Tired'
  ];

  // File Naming
  static const String pdfExtension = '.pdf';
  static const String audioExtension = '.wav';

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorMicrophonePermission = 'Microphone permission is required for recording.';
  static const String errorMandatoryFields = 'Please fill all mandatory fields.';
  static const String errorAudioRequired = 'Please record or select an audio file.';
  static const String errorAudioFormat = 'Only .wav audio format is supported.';
  static const String errorPredictionFailed = 'AI prediction failed. Please try again.';
  static const String errorUploadFailed = 'Data upload failed. Please try again.';

  // Success Messages
  static const String successPrediction = 'Prediction completed successfully.';
  static const String successUpload = 'Data uploaded successfully.';
  static const String successReportSaved = 'Report saved successfully.';
  static const String successReportShared = 'Report shared successfully.';

}
