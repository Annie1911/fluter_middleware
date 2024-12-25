import 'package:flutter/material.dart';
import 'package:programation_distribued_project/services/api_service.dart';
import '../models/log_model.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({super.key});

@override
_LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  final ApiService apiService = ApiService();
  late Future<List<LogModel>> logsFuture;

  @override
  void initState() {
    super.initState();
    logsFuture = apiService.fetchTodolistLogs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todolist Logs"),
      ),
      body: FutureBuilder<List<LogModel>>(
        future: logsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No logs found"));
          } else {
            final logs = snapshot.data!;
            return ListView.builder(
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return ListTile(
                  title: Text("${log.method} ${log.url}"),
                  subtitle: Text("Status: ${log.statusCode} | Time: ${log.processTime}s"),
                  trailing: Text(log.dateCreated.toIso8601String()),
                );
              },
            );
          }
        },
      ),
    );
  }
}
