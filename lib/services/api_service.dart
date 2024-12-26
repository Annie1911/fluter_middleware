import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/log_model.dart';


class ApiService {
static const String baseUrl = 'fastapitodolist-production.up.railway.app/logs';

Future<List<LogModel>> fetchTodolistLogs({int skip = 0, int limit = 10}) async {
  final response = await http.get(Uri.parse('$baseUrl/?skip=$skip&limit=$limit'));

  if (response.statusCode == 200) {
    List<dynamic> logsJson = json.decode(response.body);
    return logsJson.map((log) => LogModel.fromJson(log)).toList();
  } else {
    throw Exception('Failed to load logs');
  }
}
}
