import 'package:flutter/material.dart';

class MedidasDepartamentoPage extends StatefulWidget {
  final String nombrePiso;
  final String nombreDepartamento;

  const MedidasDepartamentoPage({
    super.key,
    required this.nombrePiso,
    required this.nombreDepartamento,
  });

  @override
  State<MedidasDepartamentoPage> createState() =>
      _MedidasDepartamentoPageState();
}

class _MedidasDepartamentoPageState extends State<MedidasDepartamentoPage> {
  List<Map<String, String>> aluminio = [
    {'alto': '', 'ancho': ''},
  ];
  List<Map<String, String>> vidrio = [
    {'alto': '', 'ancho': ''},
  ];

  final observacionesAluminio = TextEditingController();
  final observacionesVidrio = TextEditingController();

  String estadoSeleccionado = 'activo';

  void _agregarFila(List<Map<String, String>> lista) {
    setState(() => lista.add({'alto': '', 'ancho': ''}));
  }

  void _eliminarFila(List<Map<String, String>> lista, int index) {
    if (lista.length > 1) {
      setState(() => lista.removeAt(index));
    }
  }

  Widget _buildEstadoButton({
    required String estado,
    required String icono,
    required String texto,
  }) {
    final bool esSeleccionado = estadoSeleccionado == estado;

    return GestureDetector(
      onTap: () {
        setState(() {
          estadoSeleccionado = estado;
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
        ), // 👈 ajusta esto según lo necesites
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color:
                    esSeleccionado
                        ? const Color.fromARGB(255, 206, 16, 16)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(255, 218, 17, 17),
                  width: esSeleccionado ? 2 : 1,
                ),
              ),
              child: Image.asset('assets/images/$icono', height: 28),
            ),
            const SizedBox(height: 2),
            Text(
              texto,
              style: TextStyle(
                fontSize: 10,
                fontWeight:
                    esSeleccionado ? FontWeight.bold : FontWeight.normal,
                decoration: esSeleccionado ? TextDecoration.underline : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo({
    required String initialValue,
    required Function(String) onChanged,
  }) {
    final controller = TextEditingController(text: initialValue);
    controller.selection = TextSelection.collapsed(
      offset: controller.text.length,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: const InputDecoration(
          hintText: '...................',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildFila(int index, List<Map<String, String>> lista) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('${index + 1}', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(
            child: _buildCampo(
              initialValue: lista[index]['alto']!,
              onChanged: (val) => lista[index]['alto'] = val,
            ),
          ),
          const SizedBox(width: 5),
          const Text('X'),
          const SizedBox(width: 5),
          Expanded(
            child: _buildCampo(
              initialValue: lista[index]['ancho']!,
              onChanged: (val) => lista[index]['ancho'] = val,
            ),
          ),
          const SizedBox(width: 20),
          AnimatedScaleButton(
            onTap: () {
              // acción futura de editar
            },
            child: Image.asset('assets/images/editar.png', height: 26),
          ),
          const SizedBox(width: 20),
          lista.length > 1
              ? AnimatedScaleButton(
                onTap: () => _eliminarFila(lista, index),
                child: Image.asset('assets/images/eliminar.png', height: 30),
              )
              : AnimatedScaleButton(
                onTap: () {}, // no hace nada, solo animación visual
                child: Opacity(
                  opacity: 0.3,
                  child: Image.asset('assets/images/eliminar.png', height: 30),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildSeccion({
    required String titulo,
    required List<Map<String, String>> lista,
    required VoidCallback onAgregar,
    required VoidCallback onGuardar,
    required TextEditingController observacionesController,
    required String iconoAgregar,
    required Color fondo,
  }) {
    return Container(
      color: fondo,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFFD9D9D9),
                  child: Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              AnimatedScaleButton(
                onTap: onGuardar,
                child: Column(
                  children: [
                    Image.asset('assets/images/guardar.png', height: 36),
                    const SizedBox(height: 4),
                    const Text('Guardar', style: TextStyle(fontSize: 9)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 120),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 25,
                      alignment: Alignment.center,
                      child: const Text(
                        'Editar',
                        style: TextStyle(fontSize: 9),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      alignment: Alignment.center,
                      child: const Text(
                        'Eliminar',
                        style: TextStyle(fontSize: 9),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 2),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...List.generate(lista.length, (index) {
            return _buildFila(index, lista);
          }),
          const SizedBox(height: 20),
          Center(
            child: AnimatedScaleButton(
              onTap: onAgregar,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 133, 163, 188),
                  border: Border.all(
                    color: const Color.fromARGB(255, 180, 50, 50),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        104,
                        25,
                        25,
                      ).withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/$iconoAgregar', height: 30),
                    const SizedBox(height: 4),
                    const Text(
                      'Añadir',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 0.01),
          const Text('Observaciones', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 0.01),
          Container(
            height: 47.6,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red),
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: TextField(
              controller: observacionesController,
              maxLines: null,
              expands: true,
              decoration: const InputDecoration.collapsed(
                hintText:
                    '..................................................................',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: const Color(0xFFD9D9D9),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 12,
                  top: 40,
                  bottom: 4,
                ), // 👈 aquí lo ajustas
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.nombrePiso} - ${widget.nombreDepartamento}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 40),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSeccion(
                        titulo: 'Aluminio',
                        lista: aluminio,
                        onAgregar: () => _agregarFila(aluminio),
                        onGuardar: () {},
                        observacionesController: observacionesAluminio,
                        iconoAgregar: 'aluminio.png',
                        fondo: const Color.fromARGB(217, 221, 221, 221),
                      ),
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: _buildSeccion(
                          titulo: 'Vidrio',
                          lista: vidrio,
                          onAgregar: () => _agregarFila(vidrio),
                          onGuardar: () {},
                          observacionesController: observacionesVidrio,
                          iconoAgregar: 'vidrio.png',
                          fondo: const Color(0xFF7EC4FA),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 24,
            child: Container(color: const Color(0xFF7EC4FA)),
          ),
        ],
      ),
      bottomNavigationBar: Transform.translate(
        offset: const Offset(0, -20),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: Container(
            color: Colors.white,
            child: NavigationBar(
              height: 60,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 2,
              selectedIndex: [
                'activo',
                'inactivo',
                'listo',
              ].indexOf(estadoSeleccionado),
              onDestinationSelected: (index) {
                setState(() {
                  estadoSeleccionado = ['activo', 'inactivo', 'listo'][index];
                });
              },
              destinations: [
                _buildEstadoButton(
                  estado: 'activo',
                  icono: 'activo.png',
                  texto: 'activo',
                ),
                _buildEstadoButton(
                  estado: 'inactivo',
                  icono: 'inactivo.png',
                  texto: 'inactivo',
                ),
                _buildEstadoButton(
                  estado: 'listo',
                  icono: 'listo.png',
                  texto: 'listo',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

  void _onTapDown(_) => setState(() => _scale = 0.92);
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
        duration: const Duration(milliseconds: 120),
        child: widget.child,
      ),
    );
  }
}
