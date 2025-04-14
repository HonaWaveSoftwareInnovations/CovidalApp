import 'package:flutter/material.dart';

class AsistenciaEdificioPage extends StatelessWidget {
  const AsistenciaEdificioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencia Edificio'),
        backgroundColor: Color(0xFF008CFF),
      ),
      body: const Center(
        child: Text(
          'Pantalla Asistencia Edificio',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
