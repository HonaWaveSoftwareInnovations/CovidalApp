import 'package:flutter/material.dart';

class ReportesGeneralesPage extends StatelessWidget {
  const ReportesGeneralesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportes Generales'),
        backgroundColor: Color(0xFF008CFF),
      ),
      body: const Center(
        child: Text(
          'Pantalla Reportes Generales',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
