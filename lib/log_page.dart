import 'package:flutter/material.dart';


class LogApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,

      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final List<Widget> pages = [
    HomeScreen(),
    LogScreen(),
    PlaceholderWidget(label: 'Settings'),
  ];

  final List<String> titles = [
    'Home',
    'Logs',
    'Settings',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[currentIndex]),
      ),
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Logs'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

class LogScreen extends StatelessWidget {
  final List<Map<String, String>> logs = [
    {'timestamp': '2024-12-10 10:00:00', 'level': 'INFO', 'message': 'Application started.'},
    {'timestamp': '2024-12-10 10:05:23', 'level': 'WARNING', 'message': 'High memory usage detected.'},
    {'timestamp': '2024-12-10 10:10:45', 'level': 'ERROR', 'message': 'Database connection failed.'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            leading: Icon(
              log['level'] == 'ERROR'
                  ? Icons.error
                  : log['level'] == 'WARNING'
                  ? Icons.warning
                  : Icons.info,
              color: log['level'] == 'ERROR'
                  ? Colors.red
                  : log['level'] == 'WARNING'
                  ? Colors.orange
                  : Colors.blue,
            ),
            title: Text(log['message']!),
            subtitle: Text(log['timestamp']!),
            trailing: Text(
              log['level']!,
              style: TextStyle(
                color: log['level'] == 'ERROR'
                    ? Colors.red
                    : log['level'] == 'WARNING'
                    ? Colors.orange
                    : Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Welcome to the Home Screen!', style: TextStyle(fontSize: 18)),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  PlaceholderWidget({required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label Screen', style: TextStyle(fontSize: 18)),
    );
  }
}
