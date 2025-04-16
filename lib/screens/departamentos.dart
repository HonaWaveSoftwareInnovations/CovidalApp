import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DepartamentosPage extends StatefulWidget {
  final String nombrePiso;
  const DepartamentosPage({required this.nombrePiso, super.key});

  @override
  State<DepartamentosPage> createState() => _DepartamentosPageState();
}

class _DepartamentosPageState extends State<DepartamentosPage> {
  List<String> seccionA = [];
  List<String> seccionB = [];
  String? seleccionado;

  @override
  void initState() {
    super.initState();
    _cargarDepartamentos();
  }

  Future<void> _cargarDepartamentos() async {
    final ref = FirebaseFirestore.instance
        .collection('edificios')
        .doc('principal')
        .collection('pisos')
        .doc(widget.nombrePiso.toLowerCase().replaceAll(' ', '_'))
        .collection('departamentos');

    final snapshot = await ref.get();

    List<String> a = [];
    List<String> b = [];

    for (var doc in snapshot.docs) {
      final nombre = doc.data()['nombre'] ?? '';
      if (nombre.startsWith('A')) {
        a.add(nombre);
      } else if (nombre.startsWith('B')) {
        b.add(nombre);
      }
    }

    setState(() {
      seccionA = a;
      seccionB = b;
    });
  }

  void _agregarDepartamento(String seccion) {
    setState(() {
      final lista = seccion == 'A' ? seccionA : seccionB;
      final numero = lista.length + 1;
      lista.add('$seccion$numero');
    });
  }

  void _eliminarDepartamento() {
    if (seleccionado == null) return;
    setState(() {
      seccionA.remove(seleccionado);
      seccionB.remove(seleccionado);
      seleccionado = null;
    });
  }

  Future<void> _guardarDepartamentos() async {
    final ref = FirebaseFirestore.instance
        .collection('edificios')
        .doc('principal')
        .collection('pisos')
        .doc(widget.nombrePiso.toLowerCase().replaceAll(' ', '_'))
        .collection('departamentos');

    final snapshot = await ref.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final todos = [...seccionA, ...seccionB];

    for (var nombre in todos) {
      await ref.doc(nombre.toLowerCase()).set({'nombre': nombre});
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Departamentos guardados')));
  }

  Widget _buildDepartamento(String nombre) {
    final esSeleccionado = nombre == seleccionado;

    return GestureDetector(
      onTap: () {
        setState(() {
          seleccionado = esSeleccionado ? null : nombre;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: esSeleccionado ? Colors.redAccent : Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          nombre,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: esSeleccionado ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSeccion(
    String titulo,
    List<String> departamentos,
    VoidCallback onAgregar,
  ) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Sección $titulo',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.black),
                onPressed: onAgregar,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                departamentos
                    .map((nombre) => _buildDepartamento(nombre))
                    .toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF098CD1), Color(0xFFE04747)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      widget.nombrePiso,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      _buildSeccion(
                        'A',
                        seccionA,
                        () => _agregarDepartamento('A'),
                      ),
                      const SizedBox(height: 20),
                      _buildSeccion(
                        'B',
                        seccionB,
                        () => _agregarDepartamento('B'),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _eliminarDepartamento,
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 38, 154, 221),
                              Color(0xFFE04747),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromARGB(255, 158, 73, 73),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/eliminar.png',
                              height: 35,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Eliminar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _guardarDepartamentos,
                      child: Container(
                        width: 90,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 38, 154, 221),
                              Color(0xFFE04747),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color.fromARGB(255, 158, 73, 73),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/guardar.png',
                              height: 35,
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Guardar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
