import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:practica1/main.dart';

import '../services/auth_service.dart';
import 'login_screen.dart';


class HomeScreen extends StatelessWidget {
  final User user;
  final AuthService authService = AuthService();

  HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hola ${user.displayName}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.singOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen())
              );
            },
          )
        ],
      ),
      body: ProductListScreen(),
    );
  }
}