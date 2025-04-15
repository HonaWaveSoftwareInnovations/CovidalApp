import 'package:flutter/material.dart';

class EdificioPage extends StatelessWidget {
  const EdificioPage({super.key});

  final List<String> pisos = const [
    'Planta Baja',
    'Piso 1',
    'Piso 2',
    'Piso 3',
    'Piso 4',
    'Piso 5',
    'Piso 6',
    'Piso 7',
    'Piso 8',
    'Piso 9',
    'Piso 10',
    'Piso 11',
    'Piso 12',
    'Piso 13',
    'Piso 14',
    'Piso 15',
    'Piso 16',
    'Piso 17',
    'Piso 18',
    'Terraza',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo degradado
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
                // AppBar personalizado
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

                // Lista de pisos y botones
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: pisos.length,
                            itemBuilder: (context, index) {
                              final piso = pisos.reversed.toList()[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 93, 180, 230),
                                        Color.fromARGB(255, 57, 118, 165),
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
                              );
                            },
                          ),
                        ),
                      ),

                      // Botones laterales
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _BotonAccion(
                              iconPath: 'assets/images/agregar.png',
                              texto: "Agregar",
                              onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            _BotonAccion(
                              iconPath: 'assets/images/eliminar.png',
                              texto: "Eliminar",
                              onTap: () {},
                            ),
                            const SizedBox(height: 20),
                            _BotonAccion(
                              iconPath: 'assets/images/guardar.png',
                              texto: "Guardar",
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Franja gris
                Container(
                  width: double.infinity,
                  height: 14,
                  color: const Color(0xFFD9D9D9),
                ),

                // Leyenda y grilla
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Leyenda izquierda
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

                      // Grilla de estados
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(20, (index) {
                            final nombres = [
                              '1',
                              '2',
                              '3',
                              '4',
                              '5',
                              '6',
                              '7',
                              '8',
                              '9',
                              '10',
                              '11',
                              '12',
                              '13',
                              '14',
                              '15',
                              '16',
                              '17',
                              '18',
                              'PB',
                              'T',
                            ];

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
                                nombres[index],
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
