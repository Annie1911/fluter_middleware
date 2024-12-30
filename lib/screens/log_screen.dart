import 'package:flutter/material.dart';
import '../models/log_model.dart';
import 'log_detail_screen.dart';
import '../services/api_service.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  _LogsScreenState createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  late Future<List<LogModel>> _logsFuture;

  @override
  void initState() {
    super.initState();
    _logsFuture = ApiService().fetchTodolistLogs(skip: 0, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todolist Logs'),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        color: Colors.white, // Fond blanc
        child: FutureBuilder<List<LogModel>>(
          future: _logsFuture,
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
                child: Text('No logs found.',
                    style: TextStyle(color: Colors.grey)),
              );
            } else {
              final logs = snapshot.data!;
              return ListView.builder(
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
              );
            }
          },
        ),
      ),
    );
  }
}

class LogCard extends StatelessWidget {
  final LogModel log;
  final VoidCallback onTap;

  const LogCard({super.key, required this.log, required this.onTap});

  Color _getStatusColor(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Colors.greenAccent; // Succès
    } else if (statusCode >= 300 && statusCode < 400) {
      return Colors.blueAccent; // Redirection
    } else if (statusCode >= 400 && statusCode < 500) {
      return Colors.orangeAccent; // Erreur client
    } else if (statusCode >= 500) {
      return Colors.redAccent; // Erreur serveur
    } else {
      return Colors.grey; // Indéterminé
    }
  }

  IconData _getStatusIcon(int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      return Icons.check_circle; // Succès
    } else if (statusCode >= 300 && statusCode < 400) {
      return Icons.sync; // Redirection
    } else if (statusCode >= 400 && statusCode < 500) {
      return Icons.warning_amber_rounded; // Erreur client
    } else if (statusCode >= 500) {
      return Icons.error; // Erreur serveur
    } else {
      return Icons.help_outline; // Indéterminé
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white, // Fond blanc
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
                    radius: 25, // Augmentation de la taille de l'icône
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
