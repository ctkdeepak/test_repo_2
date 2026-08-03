class UploadHistoryModel {
  final String id;
  final String pid;
  final String patientName;
  final String gender;
  final String age;
  final String? actualReason;
  final String? notes;
  final String audioFileName;
  final String timestamp;
  final String status;
  final String? errorMessage;
  final String operationType;
  final String? predictionLabel;
  final String? confidenceScore;

  UploadHistoryModel({
    required this.id,
    required this.pid,
    required this.patientName,
    required this.gender,
    required this.age,
    this.actualReason,
    this.notes,
    required this.audioFileName,
    required this.timestamp,
    required this.status,
    this.errorMessage,
    required this.operationType,
    this.predictionLabel,
    this.confidenceScore,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'pid': pid,
    'patientName': patientName,
    'gender': gender,
    'age': age,
    'actualReason': actualReason,
    'notes': notes,
    'audioFileName': audioFileName,
    'timestamp': timestamp,
    'status': status,
    'errorMessage': errorMessage,
    'operationType': operationType,
    'predictionLabel': predictionLabel,
    'confidenceScore': confidenceScore,
  };

  factory UploadHistoryModel.fromJson(Map<String, dynamic> json) => UploadHistoryModel(
    id: json['id'],
    pid: json['pid'],
    patientName: json['patientName'],
    gender: json['gender'],
    age: json['age'],
    actualReason: json['actualReason'],
    notes: json['notes'],
    audioFileName: json['audioFileName'],
    timestamp: json['timestamp'],
    status: json['status'],
    errorMessage: json['errorMessage'],
    operationType: json['operationType'] ?? 'upload',
    predictionLabel: json['predictionLabel'],
    confidenceScore: json['confidenceScore'],
  );

}
