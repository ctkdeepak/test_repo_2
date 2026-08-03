import 'dart:io';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String appDirectoryName = 'Baby Cry';

  static Future<String> getAppDirectoryPath() async {
    try {
      final Directory? externalDir = await getExternalStorageDirectory();
      if (externalDir != null) {
        final String appDirPath = '${externalDir.path}/$appDirectoryName';
        final Directory appDir = Directory(appDirPath);
        if (!await appDir.exists()) {
          await appDir.create(recursive: true);
        }
        return appDirPath;
      }

      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDirPath = '${appDocDir.path}/$appDirectoryName';
      final Directory appDir = Directory(appDirPath);
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      return appDirPath;

    } catch (e) {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDirPath = '${appDocDir.path}/$appDirectoryName';
      final Directory appDir = Directory(appDirPath);
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
      }
      return appDirPath;
    }
  }

  static Future<String> getRecordingsPath() async {
    final String basePath = await getAppDirectoryPath();
    final String recordingsPath = '$basePath/Recordings';
    final Directory recordingsDir = Directory(recordingsPath);
    if (!await recordingsDir.exists()) {
      await recordingsDir.create(recursive: true);
    }
    return recordingsPath;
  }

  static Future<String> getReportsPath() async {
    final String basePath = await getAppDirectoryPath();
    final String reportsPath = '$basePath/Reports';
    final Directory reportsDir = Directory(reportsPath);
    if (!await reportsDir.exists()) {
      await reportsDir.create(recursive: true);
    }
    return reportsPath;
  }

  static Future<String> getAudioFilePath(String fileName) async {
    final String recordingsPath = await getRecordingsPath();
    return '$recordingsPath/$fileName';
  }

  static Future<String> getPdfFilePath(String fileName) async {
    final String reportsPath = await getReportsPath();
    return '$reportsPath/$fileName';
  }

  static Future<bool> fileExists(String filePath) async {
    final File file = File(filePath);
    return await file.exists();
  }

  static Future<void> deleteFile(String filePath) async {
    final File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  static Future<List<File>> getAudioFiles() async {
    final String recordingsPath = await getRecordingsPath();
    final Directory recordingsDir = Directory(recordingsPath);
    if (!await recordingsDir.exists()) {
      return [];
    }
    return recordingsDir.listSync()
        .where((entity) => entity is File && entity.path.endsWith('.wav'))
        .map((entity) => entity as File)
        .toList();
  }

  static Future<List<File>> getPdfFiles() async {
    final String reportsPath = await getReportsPath();
    final Directory reportsDir = Directory(reportsPath);
    if (!await reportsDir.exists()) {
      return [];
    }
    return reportsDir.listSync()
        .where((entity) => entity is File && entity.path.endsWith('.pdf'))
        .map((entity) => entity as File)
        .toList();
  }

}
