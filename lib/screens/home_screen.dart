import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import '../services/notification_service.dart';
import '../services/websocket_service.dart'; // WebSocket service import
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String accessToken;
  late NotificationService notificationService;
  late WebSocketService websocketService;

  @override
  void initState() {
    super.initState();
    notificationService = NotificationService();
    notificationService.init();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final String? token = await getToken('access_token');
    if (token != null) {
      setState(() {
        accessToken = token;
      });
      // WebSocket service initialization and connection
      websocketService = WebSocketService(notificationService: notificationService);
      await websocketService.connectToWebSocket(
          'ws://192.168.0.109:8000/ws/notifications', accessToken);
    } else {
      // If token is not found, redirect to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person,
              color: colorScheme.primary,
              size: 30,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[200]),
            onPressed: () async {
              await logout(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/image.png'),
              fit: BoxFit.cover,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
          child: Text(
            'Welcome to the Home Screen!',
            style: TextStyle(
              fontSize: 18,
              color: colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
