import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'notification_service.dart';
import 'authentication_service.dart';

class WebSocketService {
  late WebSocket _socket;
  final NotificationService notificationService;

  WebSocketService({required this.notificationService});

  // Méthode pour établir la connexion WebSocket
  Future<void> connectToWebSocket(String url, String token) async {
    try {
      print('Connexion à WebSocket : $url');

      // Connexion au WebSocket
      _socket = await WebSocket.connect(url);
      print("WebSocket connecté");

      // Authentification via le token
      // _socket.add('Bearer $token'); // Envoi du token après la connexion

      // Écoute des messages du WebSocket
      _socket.listen(
        (data) {
          print("Message reçu : $data");
          // Affichage de la notification avec le message reçu
          notificationService.showNotification(
            0,
            "Nouvelle Notification",
            data.toString(),
          );
        },
        onError: (error) {
          print("Erreur WebSocket : $error");
        },
        onDone: () {
          print("Connexion WebSocket fermée");
        },
      );
    } catch (e) {
      print("Erreur lors de la connexion WebSocket : $e");
    }
  }

  // Méthode pour fermer la connexion WebSocket
  void closeConnection() {
    _socket.close();
    print("Connexion WebSocket fermée");
  }
}

Future<void> initializeWebSocket(
    BuildContext context, NotificationService notificationService) async {
  try {
    // Récupérer le token
    final String? token = await getToken('access_token');

    if (token == null) {
      throw Exception(
          "Token non trouvé. Assurez-vous que l'utilisateur est connecté.");
    }

    // Créer une instance de WebSocketService
    WebSocketService websocketService =
        WebSocketService(notificationService: notificationService);

    // Connexion WebSocket avec l'URL correcte
    String websocketUrl = 'ws://127.0.0.1:8000/ws/notifications';
    Uri uri = Uri.parse(websocketUrl);
    print('Connexion à l\'URL : $uri');

    // Établir la connexion WebSocket
    await websocketService.connectToWebSocket(uri.toString(), token);
  } catch (e) {
    print("Erreur lors de la connexion WebSocket : $e");
  }
}
