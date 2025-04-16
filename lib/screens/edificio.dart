import 'package:flutter/material.dart';

class EdificioPage extends StatefulWidget {
  const EdificioPage({super.key});

  @override
  State<EdificioPage> createState() => _EdificioPageState();
}

class _EdificioPageState extends State<EdificioPage> {
  List<String> pisosDinamicos = [
    'Piso 18',
    'Piso 17',
    'Piso 16',
    'Piso 15',
    'Piso 14',
    'Piso 13',
    'Piso 12',
    'Piso 11',
    'Piso 10',
    'Piso 9',
    'Piso 8',
    'Piso 7',
    'Piso 6',
    'Piso 5',
    'Piso 4',
    'Piso 3',
    'Piso 2',
    'Piso 1',
  ];

  final String terraza = 'Terraza';
  final String plantaBaja = 'Planta Baja';
  bool terrazaVisible = true;

  String? pisoSeleccionado;

  int _obtenerSiguienteNumero() {
    final regex = RegExp(r'Piso (\d+)');
    final numeros =
        pisosDinamicos
            .map((e) => regex.firstMatch(e))
            .where((e) => e != null)
            .map((e) => int.parse(e!.group(1)!))
            .toList();
    if (numeros.isEmpty) return 1;
    return numeros.reduce((a, b) => a > b ? a : b) + 1;
  }

  void _agregarPiso() {
    final nuevoNumero = _obtenerSiguienteNumero();
    setState(() {
      pisosDinamicos.insert(0, 'Piso $nuevoNumero');
    });
  }

  void _eliminarPiso() {
    if (pisoSeleccionado == null) return;

    final esDinamico = pisosDinamicos.contains(pisoSeleccionado);
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
                    pisosDinamicos.remove(pisoSeleccionado);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función guardar aún no implementada')),
    );
  }

  bool _esSeleccionado(String piso) {
    return piso == pisoSeleccionado;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> listaParaMostrar = [
      if (terrazaVisible) terraza,
      ...pisosDinamicos,
      plantaBaja,
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
                              final seleccionado = _esSeleccionado(piso);

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    if (_esSeleccionado(piso)) {
                                      setState(() {
                                        pisoSeleccionado = null;
                                      });
                                    }
                                  },
                                  onLongPress: () {
                                    if (piso != plantaBaja) {
                                      setState(() {
                                        pisoSeleccionado =
                                            pisoSeleccionado == piso
                                                ? null
                                                : piso;
                                      });
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient:
                                          seleccionado
                                              ? const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                    255,
                                                    221,
                                                    86,
                                                    86,
                                                  ),
                                                  Color.fromARGB(
                                                    255,
                                                    231,
                                                    81,
                                                    81,
                                                  ),
                                                ],
                                              )
                                              : const LinearGradient(
                                                colors: [
                                                  Color.fromARGB(
                                                    255,
                                                    93,
                                                    180,
                                                    230,
                                                  ),
                                                  Color.fromARGB(
                                                    255,
                                                    57,
                                                    118,
                                                    165,
                                                  ),
                                                ],
                                              ),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 50,
                                      ),
                                      child: Center(
                                        child: Text(
                                          piso,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
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
                            String texto;

                            if (piso == plantaBaja) {
                              texto = 'PB';
                            } else if (piso == terraza) {
                              texto = 'T';
                            } else {
                              final match = RegExp(
                                r'Piso (\d+)',
                              ).firstMatch(piso);
                              texto = match != null ? match.group(1)! : piso;
                            }

                            Color fondo;
                            if (index < 8) {
                              fondo = const Color(0xFFE04747);
                            } else if (index < 12) {
                              fondo = const Color(0xFF88BFFF);
                            } else if (index < 16) {
                              fondo = const Color(0xFF9CEC8B);
                            } else {
                              fondo = const Color(0xFF88BFFF);
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

class _BotonAccion extends StatelessWidget {
  final String iconPath;
  final String texto;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.iconPath,
    required this.texto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color.fromARGB(255, 38, 154, 221), Color(0xFFE04747)],
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromARGB(255, 158, 73, 73), width: 1),
        ),
        child: Column(
          children: [
            Image.asset(iconPath, height: 35, fit: BoxFit.contain),
            const SizedBox(height: 5),
            Text(
              texto,
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
    );
  }
}

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
