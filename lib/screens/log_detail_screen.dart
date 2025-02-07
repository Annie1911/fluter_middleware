import 'package:flutter/material.dart';
import '../../models/log_model.dart';
import '../../services/api_service.dart';

class LogDetailsScreen extends StatelessWidget {
  final int logId;

  const LogDetailsScreen({super.key, required this.logId});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Log Details"),
        backgroundColor: colorScheme.primary,
      ),
      body: FutureBuilder<LogModel>(
        future: ApiService().fetchTodoListLog(logId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Log not found."));
          }

          final log = snapshot.data!;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Icon(Icons.info, size: 30, color: colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(
                            "Log Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 1.5),
                      const SizedBox(height: 10),

                      // Status Badge
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 20),
                          decoration: BoxDecoration(
                            color: log.statusCode >= 400
                                ? Colors.redAccent
                                : Colors.greenAccent,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            log.statusCode >= 400
                                ? "Error ${log.statusCode}"
                                : "Success ${log.statusCode}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Log Details Section
                      InfoSection(
                        title: "Request Details",
                        fields: [
                          InfoField(
                            icon: Icons.http,
                            label: "Method",
                            value: log.method,
                          ),
                          InfoField(
                            icon: Icons.link,
                            label: "URL",
                            value: log.url,
                          ),
                          InfoField(
                            icon: Icons.timer,
                            label: "Process Time",
                            value: "${log.processTime} ms",
                          ),
                          InfoField(
                            icon: Icons.location_on,
                            label: "Remote Address",
                            value: log.remoteAddress,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Additional Info Section
                      InfoSection(
                        title: "Additional Information",
                        fields: [
                          InfoField(
                            icon: Icons.error_outline,
                            label: "Error Message",
                            value: (log.errorMessage ?? "").isNotEmpty ? log.errorMessage! : "None",
                          ),
                          InfoField(
                            icon: Icons.date_range,
                            label: "Date Created",
                            value: log.dateCreated.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}


class InfoSection extends StatelessWidget {
  final String title;
  final List<InfoField> fields;

  const InfoSection({super.key, required this.title, required this.fields});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary
          ),
        ),
        const SizedBox(height: 10),
        ...fields,
      ],
    );
  }
}


class InfoField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoField({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primaryContainer),
          const SizedBox(width: 10),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: colorScheme.primary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
