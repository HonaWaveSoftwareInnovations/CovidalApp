import 'package:flutter/material.dart';

class OficinaPage extends StatelessWidget {
  const OficinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Oficina'),
        backgroundColor: Color(0xFF008CFF),
      ),
      body: const Center(
        child: Text('Pantalla Oficina', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
