import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AsistenciaEdificioPage extends StatefulWidget {
  const AsistenciaEdificioPage({super.key});

  @override
  State<AsistenciaEdificioPage> createState() => _AsistenciaEdificioPageState();
}

class _AsistenciaEdificioPageState extends State<AsistenciaEdificioPage> {
  final List<Map<String, dynamic>> personal = [];
  final String fechaFirestore = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final String fechaVisual = DateFormat(
    'EEEE d/M/yyyy',
    'es_ES',
  ).format(DateTime.now());

  void agregarPersona() {
    setState(() {
      personal.add({
        'nombre': 'Nombre',
        'presente': false,
        'hora': TimeOfDay.now(),
        'editando': false,
      });
    });
  }

  void eliminarPersona(int index) {
    setState(() {
      personal.removeAt(index);
    });
  }

  void guardarAsistencia() async {
    final data =
        personal.map((p) {
          return {
            'nombre': p['nombre'],
            'presente': p['presente'],
            'hora': p['hora'].format(context),
          };
        }).toList();

    await FirebaseFirestore.instance
        .collection('asistencias')
        .doc(fechaFirestore)
        .set({'personal': data});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Asistencia guardada')));
  }

  void editarNombre(int index) {
    setState(() {
      personal[index]['editando'] = true;
    });
  }

  void actualizarNombre(int index, String value) {
    setState(() {
      personal[index]['nombre'] = value;
      personal[index]['editando'] = false;
    });
  }

  Future<void> editarHora(int index) async {
    final nuevaHora = await showTimePicker(
      context: context,
      initialTime: personal[index]['hora'],
    );
    if (nuevaHora != null) {
      setState(() {
        personal[index]['hora'] = nuevaHora;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008CFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF008CFF),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Asistencia'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Personal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  fechaVisual,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(flex: 3, child: Text('')),
                Text(
                  'Presente',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Tarde',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Editar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Text(
                  'Eliminar',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: personal.length,
              itemBuilder: (context, index) {
                final persona = personal[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      // Nombre
                      Expanded(
                        flex: 3,
                        child:
                            persona['editando']
                                ? TextField(
                                  autofocus: true,
                                  onSubmitted:
                                      (value) => actualizarNombre(index, value),
                                  decoration: InputDecoration(
                                    hintText: 'Nombre',
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: const BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                )
                                : Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Colors.blueGrey, Colors.blue],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: Text(
                                    persona['nombre'],
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                      ),
                      const SizedBox(width: 8),

                      // Presente
                      Checkbox(
                        value: persona['presente'],
                        activeColor: Colors.green,
                        onChanged: (val) {
                          setState(() {
                            persona['presente'] = val!;
                          });
                        },
                      ),
                      const SizedBox(width: 4),

                      // Hora
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () => editarHora(index),
                          child: Container(
                            height: 35,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red),
                            ),
                            child: Text(persona['hora'].format(context)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Editar
                      IconButton(
                        icon: Image.asset(
                          'assets/images/editar-usuario.png',
                          width: 22,
                          height: 22,
                        ),
                        onPressed: () => editarNombre(index),
                      ),

                      // Eliminar
                      IconButton(
                        icon: Image.asset(
                          'assets/images/borrar-usuario.png',
                          width: 23,
                          height: 23,
                        ),
                        onPressed: () => eliminarPersona(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 14,
            color: const Color(0xFFD9D9D9),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              AnimatedScaleButton(
                onTap: agregarPersona,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/agregar-usuario.png',
                      height: 40,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Agregar',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AnimatedScaleButton(
                  onTap: guardarAsistencia,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: 10),
                        const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset('assets/images/guardar.png', height: 30),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}

// Botón animado reutilizable
class AnimatedScaleButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const AnimatedScaleButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<AnimatedScaleButton> createState() => _AnimatedScaleButtonState();
}

class _AnimatedScaleButtonState extends State<AnimatedScaleButton>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.95);
  void _onTapUp(_) => setState(() => _scale = 1.0);
  void _onTapCancel() => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: widget.child,
      ),
    );
  }
}
