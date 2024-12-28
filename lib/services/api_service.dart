import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log_model.dart';
<<<<<<< HEAD

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5208/api';

  // Récupérer tous les logs
  Future<List<LogModel>> fetchTodolistLogs({int skip = 0, int limit = 10}) async {
    final response = await http.get(Uri.parse('$baseUrl/logs?skip=$skip&limit=$limit'));
=======
import 'authentication_service.dart';

class ApiService {
  static const String prodBaseUrl =
      'fastapitodolist-production.up.railway.app/logs';
  static const String devBaseUrl = 'http://192.168.0.109:8000/logs';
  Future<List<LogModel>> fetchTodolistLogs({int? skip, int? limit}) async {
    String url = '$devBaseUrl/get-logs';
    if (skip != null) {
      url += '?skip=$skip';
      if (limit!= null) {
        url += '&limit=$limit';
      }
    }
    else{
      if (limit != null) {
        url += '?limit=$limit';
      }
    }
    final token = await getToken(); // Récupération du token
    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Ajout du token dans l'en-tête
      },
    );
>>>>>>> hqh

    if (response.statusCode == 200) {
      List<dynamic> logsJson = json.decode(response.body);
      return logsJson.map((log) => LogModel.fromJson(log)).toList();
    } else {
<<<<<<< HEAD
=======
      print('Error response: ${response.body}');
>>>>>>> hqh
      throw Exception('Failed to load logs');
    }
  }

<<<<<<< HEAD
  // Récupérer un seul log par ID
  Future<LogModel> fetchLogById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/logs/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> logJson = json.decode(response.body);
      return LogModel.fromJson(logJson);
    } else if (response.statusCode == 404) {
      throw Exception('Log not found');
    } else {
      throw Exception('Failed to load log');
    }
  }
}

=======
  /// Récupération d'un log spécifique par son ID
  Future<LogModel> fetchTodoListLog(String logId) async {
    final token = await getToken(); // Récupération du token
    if (token == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$devBaseUrl/get-log/$logId'),
      headers: {
        'Authorization': 'Bearer $token', // Ajout du token dans l'en-tête
      },
    );

    if (response.statusCode == 200) {
      return LogModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load log with ID $logId');
    }
  }
}
>>>>>>> hqh
