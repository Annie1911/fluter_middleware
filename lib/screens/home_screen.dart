import 'package:flutter/material.dart';
import '../services/authentication_service.dart';
import '../services/notification_service.dart';
import '../services/websocket_service.dart'; // Importation du service WebSocket
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late String accessToken;
  late NotificationService notificationService;
  late WebSocketService websocketService; // Déclaration du service WebSocket

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
      // Initialisation du service WebSocket et connexion
      websocketService =
          WebSocketService(notificationService: notificationService);
      await websocketService.connectToWebSocket(
          'ws://192.168.0.109:8000/ws/notifications', accessToken);
    } else {
      // Si le token est introuvable, rediriger vers la page de connexion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey[200],
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.grey[200]),
            onPressed: () async {
              await logout(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to the Home Screen!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
