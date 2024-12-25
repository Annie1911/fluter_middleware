export 'log_model.dart';

class LogModel {
  final int id;
  final int statusCode;
  final String method;
  final String url;
  final String? errorMessage;
  final DateTime dateCreated;
  final double processTime;
  final String remoteAddress;

  LogModel({
    required this.id,
    required this.statusCode,
    required this.method,
    required this.url,
    this.errorMessage,
    required this.dateCreated,
    required this.processTime,
    required this.remoteAddress,
  });

  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      id: json['id'],
      statusCode: json['status_code'],
      method: json['method'],
      url: json['url'],
      errorMessage: json['error_message'],
      dateCreated: DateTime.parse(json['date_created']),
      processTime: json['process_time'],
      remoteAddress: json['remote_address'],
    );
  }
}
