class PatientInfo {

  String? pid;
  String? name;
  String? gender;
  int? day;
  int? month;
  int? year;
  String? actualReason;
  String? notes;
  String? audioFilePath;
  String? timestamp;

  PatientInfo({
    this.pid,
    this.name,
    this.gender,
    this.day,
    this.month,
    this.year,
    this.actualReason,
    this.notes,
    this.audioFilePath,
    this.timestamp,
  });

  String get ageDisplay {
    if (day == null || month == null || year == null) return '';
    return '$day days, $month months, $year years';
  }

  String get ageString {
    if (day == null || month == null || year == null) return '';
    return '${year}y ${month}m ${day}d';
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp ?? DateTime.now().toIso8601String(),
      'pid': pid ?? '',
      'name': name ?? '',
      'gender': gender ?? '',
      'age': ageString,
      'actual_reason': actualReason ?? '',
      'notes': notes ?? '',
    };
  }

  PatientInfo copyWith({
    String? pid,
    String? name,
    String? gender,
    int? day,
    int? month,
    int? year,
    String? actualReason,
    String? notes,
    String? audioFilePath,
    String? timestamp,
  }) {
    return PatientInfo(
      pid: pid ?? this.pid,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      day: day ?? this.day,
      month: month ?? this.month,
      year: year ?? this.year,
      actualReason: actualReason ?? this.actualReason,
      notes: notes ?? this.notes,
      audioFilePath: audioFilePath ?? this.audioFilePath,
      timestamp: timestamp ?? this.timestamp,
    );
  }

}
