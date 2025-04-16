import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EdificioPage extends StatefulWidget {
  const EdificioPage({super.key});

  @override
  State<EdificioPage> createState() => _EdificioPageState();
}

class _EdificioPageState extends State<EdificioPage> {
  List<Map<String, dynamic>> pisosDinamicos = [];
  final String terraza = 'Terraza';
  final String plantaBaja = 'Planta Baja';
  bool terrazaVisible = true;
  String? pisoSeleccionado;

  @override
  void initState() {
    super.initState();
    _cargarDesdeFirestore();
  }

  Future<void> _cargarDesdeFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final pisosRef = firestore
        .collection('edificios')
        .doc('principal')
        .collection('pisos');
    final snapshot = await pisosRef.orderBy('orden').get();

    List<Map<String, dynamic>> nuevosPisos = [];
    bool terrazaEstaVisible = false;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final nombre = data['nombre'] ?? '';
      final visible = data['visible'] ?? true;
      final estado = data['estado'] ?? 'inactivo';

      if (nombre == terraza) {
        terrazaEstaVisible = visible;
      } else if (nombre != plantaBaja) {
        nuevosPisos.add({'nombre': nombre, 'estado': estado});
      }
    }

    setState(() {
      terrazaVisible = terrazaEstaVisible;
      pisosDinamicos = nuevosPisos;
    });
  }

  int _obtenerSiguienteNumero() {
    final regex = RegExp(r'Piso (\d+)');
    final numeros =
        pisosDinamicos
            .map((e) => regex.firstMatch(e['nombre']))
            .where((e) => e != null)
            .map((e) => int.parse(e!.group(1)!))
            .toList();
    if (numeros.isEmpty) return 1;
    return numeros.reduce((a, b) => a > b ? a : b) + 1;
  }

  void _agregarPiso() {
    final nuevoNumero = _obtenerSiguienteNumero();
    setState(() {
      pisosDinamicos.insert(0, {
        'nombre': 'Piso $nuevoNumero',
        'estado': 'inactivo',
      });
    });
  }

  void _eliminarPiso() {
    if (pisoSeleccionado == null) return;

    final esDinamico = pisosDinamicos.any(
      (p) => p['nombre'] == pisoSeleccionado,
    );
    final esTerraza = pisoSeleccionado == terraza;

    if (!esDinamico && !esTerraza) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de eliminar el piso "$pisoSeleccionado"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  pisoSeleccionado = null;
                });
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (esDinamico) {
                    pisosDinamicos.removeWhere(
                      (p) => p['nombre'] == pisoSeleccionado,
                    );
                  } else if (esTerraza) {
                    terrazaVisible = false;
                  }
                  pisoSeleccionado = null;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _guardarCambios() {
    _guardarEnFirestore();
  }

  Future<void> _guardarEnFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final pisosRef = firestore
        .collection('edificios')
        .doc('principal')
        .collection('pisos');

    final snapshot = await pisosRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    final listaParaGuardar = [
      if (terrazaVisible) {'nombre': terraza, 'estado': 'inactivo'},
      ...pisosDinamicos,
      {'nombre': plantaBaja, 'estado': 'inactivo'},
    ];

    for (int i = 0; i < listaParaGuardar.length; i++) {
      final piso = listaParaGuardar[i];
      final nombre = piso['nombre'];
      final estado = piso['estado'];
      final id = nombre.toLowerCase().replaceAll(' ', '_');

      await pisosRef.doc(id).set({
        'nombre': nombre,
        'orden': i,
        'estado': estado,
        'visible': true,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pisos guardados en Firestore')),
    );
  }

  bool _esSeleccionado(String piso) {
    return piso == pisoSeleccionado;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> listaParaMostrar = [
      if (terrazaVisible) {'nombre': terraza, 'estado': 'inactivo'},
      ...pisosDinamicos,
      {'nombre': plantaBaja, 'estado': 'inactivo'},
    ];

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE04747), Color(0xFF098CD1)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Spacer(),
                      const Text(
                        'Pisos',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: listaParaMostrar.length,
                            itemBuilder: (context, index) {
                              final piso = listaParaMostrar[index];
                              final nombre = piso['nombre'];
                              final seleccionado = _esSeleccionado(nombre);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: _PisoItemAnimado(
                                  nombre: nombre,
                                  seleccionado: seleccionado,
                                  esPlantaBaja: nombre == plantaBaja,
                                  onTap: () {
                                    if (_esSeleccionado(nombre)) {
                                      setState(() => pisoSeleccionado = null);
                                    }
                                  },
                                  onLongPress: () {
                                    if (nombre != plantaBaja) {
                                      setState(() {
                                        pisoSeleccionado =
                                            pisoSeleccionado == nombre
                                                ? null
                                                : nombre;
                                      });
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _BotonAccion(
                              iconPath: 'assets/images/agregar.png',
                              texto: "Agregar",
                              onTap: _agregarPiso,
                            ),
                            const SizedBox(height: 20),
                            _BotonAccion(
                              iconPath: 'assets/images/eliminar.png',
                              texto: "Eliminar",
                              onTap: _eliminarPiso,
                            ),
                            const SizedBox(height: 20),
                            _BotonAccion(
                              iconPath: 'assets/images/guardar.png',
                              texto: "Guardar",
                              onTap: _guardarCambios,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 14,
                  color: const Color(0xFFD9D9D9),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          _ColorIndicadorFila(
                            color: Color(0xFF88BFFF),
                            label: 'activo',
                          ),
                          SizedBox(height: 10),
                          _ColorIndicadorFila(
                            color: Color(0xFFE04747),
                            label: 'inactivo',
                          ),
                          SizedBox(height: 10),
                          _ColorIndicadorFila(
                            color: Color(0xFF9CEC8B),
                            label: 'listo',
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(listaParaMostrar.length, (
                            index,
                          ) {
                            final piso = listaParaMostrar[index];
                            final nombre = piso['nombre'];
                            final estado = piso['estado'];

                            String texto;
                            if (nombre == plantaBaja) {
                              texto = 'PB';
                            } else if (nombre == terraza) {
                              texto = 'T';
                            } else {
                              final match = RegExp(
                                r'Piso (\d+)',
                              ).firstMatch(nombre);
                              texto = match != null ? match.group(1)! : nombre;
                            }

                            Color fondo;
                            switch (estado) {
                              case 'activo':
                                fondo = const Color(0xFF88BFFF);
                                break;
                              case 'listo':
                                fondo = const Color(0xFF9CEC8B);
                                break;
                              case 'inactivo':
                              default:
                                fondo = const Color(0xFFE04747);
                                break;
                            }

                            return Container(
                              width: 30,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: fondo,
                                border: Border.all(color: Colors.red, width: 1),
                              ),
                              child: Text(
                                texto,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// BOTÓN ANIMADO
class _BotonAccion extends StatefulWidget {
  final String iconPath;
  final String texto;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.iconPath,
    required this.texto,
    required this.onTap,
  });

  @override
  State<_BotonAccion> createState() => _BotonAccionState();
}

class _BotonAccionState extends State<_BotonAccion>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;

  void _animar() async {
    setState(() => _scale = 0.9);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 100));
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _animar,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _scale,
        child: Container(
          width: 90,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 38, 154, 221), Color(0xFFE04747)],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color.fromARGB(255, 158, 73, 73),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Image.asset(widget.iconPath, height: 35, fit: BoxFit.contain),
              const SizedBox(height: 5),
              Text(
                widget.texto,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// PISO ANIMADO
class _PisoItemAnimado extends StatefulWidget {
  final String nombre;
  final bool seleccionado;
  final bool esPlantaBaja;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _PisoItemAnimado({
    required this.nombre,
    required this.seleccionado,
    required this.esPlantaBaja,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  State<_PisoItemAnimado> createState() => _PisoItemAnimadoState();
}

class _PisoItemAnimadoState extends State<_PisoItemAnimado> {
  double _scale = 1.0;

  void _animar(VoidCallback callback) async {
    setState(() => _scale = 0.9);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() => _scale = 1.0);
    await Future.delayed(const Duration(milliseconds: 100));
    callback();
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        widget.seleccionado
            ? const LinearGradient(
              colors: [
                Color.fromARGB(255, 221, 86, 86),
                Color.fromARGB(255, 231, 81, 81),
              ],
            )
            : const LinearGradient(
              colors: [
                Color.fromARGB(255, 93, 180, 230),
                Color.fromARGB(255, 57, 118, 165),
              ],
            );

    return GestureDetector(
      onTap: () => _animar(widget.onTap),
      onLongPress: () => _animar(widget.onLongPress),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red, width: 1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 50),
          child: Center(
            child: Text(
              widget.nombre,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// CÍRCULOS DE COLOR
class _ColorIndicadorFila extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorIndicadorFila({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
