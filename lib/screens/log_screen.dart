import 'package:flutter/material.dart';
import '../models/log_model.dart';
import 'log_detail_screen.dart';
import '../services/api_service.dart';


class LogsScreenPage extends StatefulWidget {
  const LogsScreenPage({super.key});


  @override
  _LogsScreenPageState createState() => _LogsScreenPageState();
}

class _LogsScreenPageState extends State<LogsScreenPage> {
  late Future<List<LogModel>> logsFuture;

  @override
  void initState() {
    super.initState();
    logsFuture = ApiService().fetchTodolistLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<LogModel>>(
        future: logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.redAccent),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Aucun log disponible',
                style: TextStyle(color: Colors.grey),
              ),
            );
          } else {
            final logs = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildStatusChart(logs),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: logs.length,
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      return LogCard(
                        log: log,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LogDetailsScreen(logId: log.id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildStatusChart(List<LogModel> logs) {
    int success = logs.where((log) => log.statusCode == 200).length;
    int error = logs.length - success;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStatusBar('Success', success, Colors.green),
        const SizedBox(width: 10),
        _buildStatusBar('Error', error, Colors.red),
      ],
    );
  }

  Widget _buildStatusBar(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          height: 20,
          width: 100,
          color: color,
          child: Center(
            child: Text(
              '$label: $count',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class LogCard extends StatelessWidget {
  final LogModel log;
  final VoidCallback onTap;


  const LogCard({super.key, required this.log, required this.onTap});

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.greenAccent;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blueAccent;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orangeAccent;
    } else if (statusCode >= 500) {
      return Colors.redAccent;
    } else {
      return Colors.grey;
    }
  }

  IconData _getStatusIcon(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Icons.check_circle;
    } else if (statusCode >= 300 && statusCode < 400) {
      return Icons.sync;
    } else if (statusCode >= 400 && statusCode < 500) {
      return Icons.warning_amber_rounded;
    } else if (statusCode >= 500) {
      return Icons.error;
    } else {
      return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: _getStatusColor(log.statusCode),
                    child: Icon(
                      _getStatusIcon(log.statusCode),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Log #${log.id}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Chip(
                    label: Text(
                      log.statusCode.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(log.statusCode),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                log.url,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    log.method.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    log.dateCreated.toString(),
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
