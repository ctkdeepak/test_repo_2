import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:baby_cry_analysis_app/models/patient_info.dart';
import 'package:baby_cry_analysis_app/models/upload_history_model.dart';
import 'package:baby_cry_analysis_app/services/api_service.dart';
import 'package:baby_cry_analysis_app/services/storage_services.dart';
import 'package:baby_cry_analysis_app/services/upload_history_service.dart';
import 'package:baby_cry_analysis_app/utils/constants.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:record/record.dart';

class BabyCryAnalysisController extends GetxController {

  PatientInfo _patientInfo = PatientInfo();
  PatientInfo get patientInfo => _patientInfo;

  final DateTime reportGenerationTime = DateTime.now();

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool get isRecording => _isRecording;

  bool _isRecordingPaused = false;
  bool get isRecordingPaused => _isRecordingPaused;

  String? _recordingPath;
  String? get recordingPath => _recordingPath;

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isUploading = false;
  bool get isUploading => _isUploading;

  String? _predictionLabel;
  String? get predictionLabel => _predictionLabel;

  String? _confidenceScore;
  String? get confidenceScore => _confidenceScore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Duration _audioDuration = Duration.zero;
  Duration get audioDuration => _audioDuration;

  Duration _audioPosition = Duration.zero;
  Duration get audioPosition => _audioPosition;

  Duration _recordingDuration = Duration.zero;
  Duration get recordingDuration => _recordingDuration;
  Timer? _recordingTimer;

  String? _audioSourceType;
  String? get audioSourceType => _audioSourceType;

  String? _uploadedFileName;
  String? get uploadedFileName => _uploadedFileName;

  bool get isFormValid {
    return _patientInfo.pid != null && _patientInfo.pid!.isNotEmpty &&
        _patientInfo.name != null && _patientInfo.name!.isNotEmpty &&
        _patientInfo.gender != null && _patientInfo.gender!.isNotEmpty &&
        _patientInfo.day != null && _patientInfo.month != null && _patientInfo.year != null;
  }

  bool get isAudioAvailable => _recordingPath != null;

  @override
  void onInit() {
    super.onInit();
    _initAudioPlayerListeners();
  }

  void _initAudioPlayerListeners() {
    _audioPlayer.onDurationChanged.listen((duration) {
      _audioDuration = duration;
      update();
    });

    _audioPlayer.onPositionChanged.listen((position) {
      _audioPosition = position;
      update();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying = false;
      _audioPosition = _audioDuration;
      update();
    });
  }

  void updatePatientInfo({
    String? pid,
    String? name,
    String? gender,
    int? day,
    int? month,
    int? year,
    String? actualReason,
    String? notes,
  }) {
    _patientInfo = _patientInfo.copyWith(
      pid: pid,
      name: name,
      gender: gender,
      day: day,
      month: month,
      year: year,
      actualReason: actualReason,
      notes: notes,
      timestamp: DateTime.now().toIso8601String(),
    );
    update();
  }

  Future<bool> checkMicrophonePermission() async {
    return await _recorder.hasPermission();
  }

  Future<void> startRecording() async {
    try {
      _uploadedFileName = null;
      _audioSourceType = null;

      final hasPermission = await checkMicrophonePermission();
      if (!hasPermission) {
        throw Exception(AppConstants.errorMicrophonePermission);
      }

      await _resetAudioState();

      final fileName = _generateAudioFileName();

      final filePath = await StorageService.getAudioFilePath(fileName);

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          bitRate: 128000,
        ),
        path: filePath,
      );

      _isRecording = true;
      _isRecordingPaused = false;
      _recordingDuration = Duration.zero;
      _audioSourceType = 'recorded';
      _startTimer();
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await _recorder.stop();
      if (path != null) {
        _recordingPath = path;
        _patientInfo = _patientInfo.copyWith(audioFilePath: path);
        _audioPosition = Duration.zero;
        _audioDuration = Duration.zero;
        _isPlaying = false;
      }

      _isRecording = false;
      _isRecordingPaused = false;
      _stopTimer();
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> pauseRecording() async {
    try {
      await _recorder.pause();
      _isRecordingPaused = true;
      _stopTimer();
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> resumeRecording() async {
    try {
      await _recorder.resume();
      _isRecordingPaused = false;
      _startTimer();
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> cancelRecording() async {
    try {
      await _recorder.cancel();
      _isRecording = false;
      _isRecordingPaused = false;
      _stopTimer();
      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
        _recordingPath = null;
        _patientInfo = _patientInfo.copyWith(audioFilePath: null);
        _audioSourceType = null;
      }
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> playAudio() async {
    try {
      if (_recordingPath == null) return;

      if (_audioPosition == _audioDuration && _audioDuration > Duration.zero) {
        await _audioPlayer.seek(Duration.zero);
        _audioPosition = Duration.zero;
      }

      await _audioPlayer.play(DeviceFileSource(_recordingPath!));
      _isPlaying = true;
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> pauseAudio() async {
    try {
      await _audioPlayer.pause();
      _isPlaying = false;
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
      _isPlaying = false;
      _audioPosition = Duration.zero;
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> seekAudio(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _audioPosition = position;
      update();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> discardRecording() async {
    await stopAudio();
    await _resetAudioState();

    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (await file.exists()) {
        await file.delete();
      }
      _recordingPath = null;
      _patientInfo = _patientInfo.copyWith(audioFilePath: null);
      _audioSourceType = null;
      _uploadedFileName = null;
    }
    update();
  }

  Future<void> _resetAudioState() async {
    await _audioPlayer.stop();
    _isPlaying = false;
    _audioPosition = Duration.zero;
    _audioDuration = Duration.zero;
    update();
  }

  void setAudioFile(String path, String fileName) {
    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
      _recordingPath = null;
    }

    _resetAudioState();
    _recordingPath = path;
    _patientInfo = _patientInfo.copyWith(audioFilePath: path);
    _audioPosition = Duration.zero;
    _audioDuration = Duration.zero;
    _audioSourceType = 'uploaded';
    _uploadedFileName = fileName;
    update();
  }

  Future<bool> uploadData() async {
    if (!isFormValid) {
      _errorMessage = AppConstants.errorMandatoryFields;
      update();
      return false;
    }

    if (_recordingPath == null) {
      _errorMessage = AppConstants.errorAudioRequired;
      update();
      return false;
    }

    _isUploading = true;
    _errorMessage = null;
    update();

    try {
      final audioFile = File(_recordingPath!);
      final result = await _apiService.uploadData(
        patientInfo: _patientInfo,
        audioFile: audioFile,
      );

      _isUploading = false;
      update();

      if (result['status'] == 'success') {
        await _saveToHistory(
          status: 'success',
          operationType: 'upload',
          errorMessage: null,
        );
        return true;
      } else {
        final errorMsg = result['message'] ?? AppConstants.errorUploadFailed;
        await _saveToHistory(
          status: 'failed',
          operationType: 'upload',
          errorMessage: errorMsg,
        );
        throw Exception(errorMsg);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isUploading = false;
      await _saveToHistory(
        status: 'failed',
        operationType: 'upload',
        errorMessage: e.toString(),
      );
      update();
      return false;
    }
  }

  Future<Map<String, dynamic>?> predictCry() async {
    if (!isFormValid) {
      _errorMessage = AppConstants.errorMandatoryFields;
      update();
      return null;
    }

    if (_recordingPath == null) {
      _errorMessage = AppConstants.errorAudioRequired;
      update();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    update();

    try {
      final audioFile = File(_recordingPath!);
      final result = await _apiService.analyzeCry(
        patientInfo: _patientInfo,
        audioFile: audioFile,
      );

      if (result['status'] == 'success') {
        _predictionLabel = result['prediction'];
        _confidenceScore = result['confidence'];
        _isLoading = false;

        await _saveToHistory(
          status: 'success',
          operationType: 'prediction',
          errorMessage: null,
          predictionLabel: _predictionLabel,
          confidenceScore: _confidenceScore,
        );

        update();
        return result;
      } else {
        final errorMsg = result['message'] ?? AppConstants.errorPredictionFailed;
        await _saveToHistory(
          status: 'failed',
          operationType: 'prediction',
          errorMessage: errorMsg,
        );
        throw Exception(errorMsg);
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      await _saveToHistory(
        status: 'failed',
        operationType: 'prediction',
        errorMessage: e.toString(),
      );
      update();
      return null;
    }
  }

  Future<void> _saveToHistory({
    required String status,
    required String operationType,
    String? errorMessage,
    String? predictionLabel,
    String? confidenceScore,
  }) async {
    final historyService = UploadHistoryService();
    final record = UploadHistoryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pid: _patientInfo.pid ?? 'N/A',
      patientName: _patientInfo.name ?? 'N/A',
      gender: _patientInfo.gender ?? 'N/A',
      age: _patientInfo.ageDisplay,
      actualReason: _patientInfo.actualReason,
      notes: _patientInfo.notes,
      audioFileName: _recordingPath?.split('/').last ?? 'N/A',
      timestamp: DateFormat('dd/MM/yyyy hh:mm:ss a').format(DateTime.now()),
      status: status,
      errorMessage: errorMessage,
      operationType: operationType,
      predictionLabel: predictionLabel,
      confidenceScore: confidenceScore,
    );
    await historyService.saveRecord(record);
  }

  void reset() {
    _stopTimer();
    _recordingDuration = Duration.zero;
    _recordingPath = null;
    _predictionLabel = null;
    _confidenceScore = null;
    _errorMessage = null;
    _isLoading = false;
    _isUploading = false;
    _isRecording = false;
    _isRecordingPaused = false;
    _isPlaying = false;
    _audioDuration = Duration.zero;
    _audioPosition = Duration.zero;
    _audioSourceType = null;
    _uploadedFileName = null;
    _patientInfo = PatientInfo();
    stopAudio();
    update();
  }

  void _startTimer() {
    _stopTimer();
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isRecordingPaused) {
        _recordingDuration = Duration(seconds: _recordingDuration.inSeconds + 1);
        update();
      }
    });
  }

  void _stopTimer() {
    _recordingTimer?.cancel();
    _recordingTimer = null;
  }

  String _generateAudioFileName() {
    final now = DateTime.now();
    final dateStr = '${now.day.toString().padLeft(2, '0')}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.year}'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}'
        '${now.second.toString().padLeft(2, '0')}';
    final pid = _patientInfo.pid ?? 'unknown';
    return '${pid}_$dateStr${AppConstants.audioExtension}';
  }

  @override
  void onClose() {
    _stopTimer();
    _recorder.dispose();
    _audioPlayer.dispose();
    _apiService.dispose();
    super.onClose();
  }

}
