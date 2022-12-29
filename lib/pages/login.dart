import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'chat.dart';

class UserData {
  final String id;
  final String username;
  final String auth;
  final String status;
  final String avatar;

  const UserData({
    required this.id,
    required this.username,
    required this.auth,
    required this.status,
    required this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    var data = json['data'];
    return UserData(
      id: data['id'].toString(),
      username: data['username'].toString(),
      auth: data['auth'].toString(),
      status: data['status'].toString(),
      avatar: data['avatar'].toString(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final username = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar sesión'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: username,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Nombre de usuario',
            ),
          ),
          TextField(
            controller: password,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Contraseña',
            ),
          ),
          ElevatedButton(
              onPressed: () {
                login();
              },
              child: const Text("Entrar")),
        ],
      )),
    );
  }

  Future<void> login() async {
    if (username.text.isNotEmpty && password.text.isNotEmpty) {
      var response = await http.post(Uri.parse("http://localhost:8000/login"),
          body: jsonEncode(
              {"username": username.text, "password": password.text}));
      if (response.statusCode == 200) {
        if (!mounted) return;
        var jsonResponse = jsonDecode(response.body);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Chat(user: UserData.fromJson(jsonResponse))));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('¡Error al iniciar sesión!'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('¡Por favor, rellena todos los campos!'),
      ));
    }
  }
}
