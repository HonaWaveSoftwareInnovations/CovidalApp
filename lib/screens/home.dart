import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla Principal'),
        backgroundColor: const Color(0xFFF26262),
      ),
      body: const Center(
        child: Text(
          '¡Bienvenido a la app Covidal!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
