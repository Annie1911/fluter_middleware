import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
export 'authentication_service.dart';
import '../screens/log_page.dart';


const String prodBaseUrl = 'fastapitodolist-production.up.railway.app/users';
const String devBaseUrl = 'http://192.168.0.109:8000/users';
Future<void> login(
    String username, String password, BuildContext context) async {
  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
    return;
  }

  final url = Uri.parse('$devBaseUrl/login');
  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('access_token') &&
          responseData['access_token'] != null &&
          responseData['access_token'] is String) {
        final String token = responseData['access_token'];
        await saveToken(token); // Sauvegarde du token dans SharedPreferences

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LogApp()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Échec de la connexion. Token invalide.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Échec de la connexion. Vérifiez vos informations.')),
      );
    }
  } catch (e) {
    print('Erreur: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur de connexion. Veuillez réessayer.')),
    );
  }
}

Future<void> refreshToken() async {
  final url = Uri.parse('$devBaseUrl/refresh-token');
  String? refreshToken = await getToken();

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'refresh_token': refreshToken??'',
        'token_type': 'bearer'
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String newToken = responseData['access_token'];
      await saveToken(
          newToken); // Mettre à jour le token dans SharedPreferences
    } else {
      print('Failed to refresh token.');
    }
  } catch (e) {
    print('Erreur: $e');
  }
}

Future<void> saveToken(String token) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', token);
}

Future<String?> getToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<void> register(
    String username, String password, BuildContext context) async {
  final url = Uri.parse('$devBaseUrl/create-user');

  if (username.isEmpty || password.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Veuillez remplir tous les champs.')),
    );
    return;
  }

  try {
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (responseData.containsKey('access_token') &&
          responseData['access_token'] != null &&
          responseData['access_token'] is String) {
        final String token = responseData['access_token'];
        await saveToken(token); // Sauvegarde du token dans SharedPreferences

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inscription réussie')),
        );

        await login(username, password, context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Inscription réussie, mais token manquant ou invalide.')),
        );
      }
    } else {
      String errorMessage =
          'Échec de l\'inscription. Code: ${response.statusCode}';
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> errorData = jsonDecode(response.body);
        if (errorData.containsKey('message')) {
          errorMessage = errorData['message'];
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erreur d\'inscription: ${e.toString()}')),
    );
  }
}
