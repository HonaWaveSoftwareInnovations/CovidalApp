import 'package:flutter/material.dart';

class EdificioPage extends StatelessWidget {
  const EdificioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edificio'),
        backgroundColor: Color(0xFF008CFF),
      ),
      body: const Center(
        child: Text('Pantalla Edificio', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
