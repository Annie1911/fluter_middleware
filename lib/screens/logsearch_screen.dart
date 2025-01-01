import 'package:flutter/material.dart';
import 'package:programation_distribued_project/screens/log_detail_screen.dart';
import '../../models/log_model.dart';
import '../../services/api_service.dart';

class LogSearchScreen extends StatefulWidget {
  const LogSearchScreen({super.key});

  @override
  State<LogSearchScreen> createState() => _LogSearchScreenState();
}

class _LogSearchScreenState extends State<LogSearchScreen> {
  final TextEditingController searchController = TextEditingController();
  String filterType = 'id'; // Default filter type
  List<LogModel> logs = [];
  bool isLoading = false;

  Future<void> searchLogs() async {
    setState(() => isLoading = true);
    try {
      List<LogModel> fetchedLogs;
      final searchValue = searchController.text.trim();

      if (filterType == 'id') {
        fetchedLogs = searchValue.isNotEmpty
            ? [await ApiService().fetchTodoListLog(int.parse(searchValue))]
            : [];
      } else if (filterType == 'date_created') {
        fetchedLogs = await ApiService().fetchTodolistLogs(
          skip: null,
          limit: null,
        );
        fetchedLogs = fetchedLogs.where((log) => log.dateCreated.toString().contains(searchValue)).toList();
      } else if (filterType == 'url') {
        fetchedLogs = await ApiService().fetchTodolistLogs(
          skip: null,
          limit: null,
        );
        fetchedLogs = fetchedLogs.where((log) => log.url.contains(searchValue)).toList();
      } else {
        fetchedLogs = [];
      }

      setState(() => logs = fetchedLogs);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search Logs"),
          backgroundColor: colorScheme.primary,
          elevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(color: colorScheme.onBackground),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: colorScheme.surfaceVariant,
                        labelText: "Search logs",
                        labelStyle: TextStyle(color: colorScheme.primary),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: filterType,
                    dropdownColor: colorScheme.background,
                    items: const [
                      DropdownMenuItem(value: 'id', child: Text("ID")),
                      DropdownMenuItem(value: 'date_created', child: Text("Date")),
                      DropdownMenuItem(value: 'url', child: Text("URL")),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => filterType = value);
                      }
                    },
                    style: TextStyle(color: colorScheme.onBackground),
                    iconEnabledColor: colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: Icon(Icons.search, color: colorScheme.primary),
                    onPressed: searchLogs,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                child: logs.isEmpty
                    ? const Center(child: Text("No logs found.", style: TextStyle(color: Colors.black)))
                    : ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(15),
                        title: Text("Log ID: ${log.id}", style: TextStyle(color: colorScheme.onBackground, fontWeight: FontWeight.bold)),
                        subtitle: Text("URL: ${log.url}", style: TextStyle(color: colorScheme.onBackground)),
                        trailing: Text("Status: ${log.statusCode}", style: TextStyle(color: colorScheme.onBackground)),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LogDetailsScreen(logId: log.id)));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
