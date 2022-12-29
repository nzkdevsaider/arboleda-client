import 'package:flutter/material.dart';

import 'login.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Arboleda'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            '¡Bievenido/a a Arboleda!',
          ),
          const Text("Elige entre iniciar sesión o registrarte."),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginForm()));
              },
              child: const Text("Iniciar sesión")),
          ElevatedButton(onPressed: () {}, child: const Text("Registrarse")),
        ],
      )),
    );
  }
}
