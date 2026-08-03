import 'package:baby_cry_analysis_app/models/upload_history_model.dart';
import 'package:get_storage/get_storage.dart';

class UploadHistoryService {
  final GetStorage _storage = GetStorage();
  static const String _key = 'upload_history';

  Future<void> saveRecord(UploadHistoryModel record) async {
    final List<dynamic> history = _storage.read(_key) ?? [];
    history.add(record.toJson());
    await _storage.write(_key, history);
  }

  List<UploadHistoryModel> getRecords() {
    final List<dynamic> history = _storage.read(_key) ?? [];
    return history.map((json) => UploadHistoryModel.fromJson(json)).toList();
  }

  List<UploadHistoryModel> getRecordsByPid(String pid) {
    final List<UploadHistoryModel> allRecords = getRecords();
    return allRecords.where((record) => record.pid == pid).toList();
  }

  Future<void> clearHistory() async {
    await _storage.remove(_key);
  }

  Future<void> deleteRecord(String id) async {
    final List<dynamic> history = _storage.read(_key) ?? [];
    history.removeWhere((json) => json['id'] == id);
    await _storage.write(_key, history);
  }

  int getSuccessCount() {
    final records = getRecords();
    return records.where((record) => record.status == 'success').length;
  }

  int getTotalCount() {
    return getRecords().length;
  }

  int getUploadCount() {
    final records = getRecords();
    return records.where((record) =>
    record.status == 'success' && record.operationType == 'upload'
    ).length;
  }

  int getPredictionCount() {
    final records = getRecords();
    return records.where((record) =>
    record.status == 'success' && record.operationType == 'prediction'
    ).length;
  }

}
