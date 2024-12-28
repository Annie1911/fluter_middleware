import 'package:flutter/material.dart';
import 'log_screen.dart';

class LogApp extends StatelessWidget {
  const LogApp({super.key});

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
  const MainScreen({super.key});

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
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Logs'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
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

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
          Text('Welcome to the Home Screen!', style: TextStyle(fontSize: 18)),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('$label Screen', style: const TextStyle(fontSize: 18)),
    );
  }
}
