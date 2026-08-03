import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:baby_cry_analysis_app/models/patient_info.dart';
import 'package:baby_cry_analysis_app/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {

  final http.Client _client;
  ApiService() : _client = http.Client();

  Future<Map<String, dynamic>> uploadData({required PatientInfo patientInfo, required File audioFile}) async {
    try {
      print('========================================');
      print('UPLOAD DATA API CALL');
      print('========================================');
      print('Endpoint: ${AppConstants.uploadEndpoint}');
      print('Audio File: ${audioFile.path.split('/').last}');
      print('Patient Info:');
      print('- PID: ${patientInfo.pid}');
      print('- Name: ${patientInfo.name}');
      print('- Gender: ${patientInfo.gender}');
      print('- Age: ${patientInfo.ageString}');
      print('- Actual Reason: ${patientInfo.actualReason}');
      print('- Notes: ${patientInfo.notes}');
      print('- Timestamp: ${patientInfo.timestamp}');
      print('========================================');

      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.uploadEndpoint}');
      print('Full URL: $uri');
      print('----------------------------------------');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['timestamp'] = patientInfo.timestamp ?? DateTime.now().toIso8601String();
      request.fields['pid'] = patientInfo.pid ?? '';
      request.fields['name'] = patientInfo.name ?? '';
      request.fields['gender'] = patientInfo.gender ?? '';
      request.fields['age'] = patientInfo.ageString;
      request.fields['actual_reason'] = patientInfo.actualReason ?? '';
      request.fields['notes'] = patientInfo.notes ?? '';

      print('Sending Form Fields:');
      request.fields.forEach((key, value) {
        print('   $key: $value');
      });
      print('----------------------------------------');

      final fileStream = http.ByteStream(audioFile.openRead());
      final fileLength = await audioFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: audioFile.path.split('/').last,
        contentType: MediaType('audio', 'wav'),
      );
      request.files.add(multipartFile);
      print('Audio File Size: ${(fileLength / 1024).toStringAsFixed(2)} KB');
      print('Audio File Name: ${audioFile.path.split('/').last}');
      print('========================================');
      print('Sending request...');

      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          print('Request Timeout after 60 seconds');
          throw Exception(AppConstants.errorNetwork);
        },
      );

      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);

      print('========================================');
      print('UPLOAD DATA RESPONSE');
      print('========================================');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(json.encode(responseData));
      print('========================================');

      if (response.statusCode == 200) {
        print('Data uploaded successfully!');
        return responseData;
      } else {
        print('Server Error: ${response.statusCode}');
        throw Exception(responseData['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('========================================');
      print('UPLOAD DATA ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      if (e.toString().contains('Connection') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException')) {
        throw Exception(AppConstants.errorNetwork);
      }
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>> analyzeCry({required PatientInfo patientInfo, required File audioFile}) async {
    try {
      print('========================================');
      print('AI PREDICTION API CALL');
      print('========================================');
      print('Endpoint: ${AppConstants.analyzeEndpoint}');
      print('Audio File: ${audioFile.path.split('/').last}');
      print('Patient Info:');
      print('- PID: ${patientInfo.pid}');
      print('- Name: ${patientInfo.name}');
      print('- Gender: ${patientInfo.gender}');
      print('- Age: ${patientInfo.ageString}');
      print('- Actual Reason: ${patientInfo.actualReason}');
      print('- Notes: ${patientInfo.notes}');
      print('- Timestamp: ${patientInfo.timestamp}');
      print('========================================');

      final uri = Uri.parse('${AppConstants.baseUrl}${AppConstants.analyzeEndpoint}');
      print('Full URL: $uri');
      print('----------------------------------------');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Content-Type'] = 'multipart/form-data';

      request.fields['timestamp'] = patientInfo.timestamp ?? DateTime.now().toIso8601String();
      request.fields['pid'] = patientInfo.pid ?? '';
      request.fields['name'] = patientInfo.name ?? '';
      request.fields['gender'] = patientInfo.gender ?? '';
      request.fields['age'] = patientInfo.ageString;
      request.fields['actual_reason'] = patientInfo.actualReason ?? '';
      request.fields['notes'] = patientInfo.notes ?? '';

      print('Sending Form Fields:');
      request.fields.forEach((key, value) {
        print('   $key: $value');
      });
      print('----------------------------------------');

      final fileStream = http.ByteStream(audioFile.openRead());
      final fileLength = await audioFile.length();
      final multipartFile = http.MultipartFile(
        'file',
        fileStream,
        fileLength,
        filename: audioFile.path.split('/').last,
        contentType: MediaType('audio', 'wav'),
      );
      request.files.add(multipartFile);
      print('Audio File Size: ${(fileLength / 1024).toStringAsFixed(2)} KB');
      print('Audio File Name: ${audioFile.path.split('/').last}');
      print('========================================');
      print('Sending AI prediction request...');

      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          print('Request Timeout after 60 seconds');
          throw Exception(AppConstants.errorNetwork);
        },
      );

      final responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);

      print('========================================');
      print('AI PREDICTION RESPONSE');
      print('========================================');
      print('Status Code: ${response.statusCode}');
      print('Response Body:');
      print(json.encode(responseData));
      print('========================================');
      print('Prediction Result:');
      print('- Label: ${responseData['prediction'] ?? 'N/A'}');
      print('- Confidence: ${responseData['confidence'] ?? 'N/A'}');
      print('========================================');

      if (response.statusCode == 200) {
        print('Prediction completed successfully!');
        return responseData;
      } else {
        print('Server Error: ${response.statusCode}');
        throw Exception(responseData['message'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('========================================');
      print('AI PREDICTION ERROR');
      print('========================================');
      print('Error: $e');
      print('========================================');
      if (e.toString().contains('Connection') ||
          e.toString().contains('timeout') ||
          e.toString().contains('SocketException')) {
        throw Exception(AppConstants.errorNetwork);
      }
      throw Exception(e.toString());
    }
  }

  void dispose() {
    _client.close();
  }

}
