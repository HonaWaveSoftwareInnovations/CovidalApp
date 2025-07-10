import 'package:flutter/material.dart';

class AsistenciaEdificioPage extends StatelessWidget {
  const AsistenciaEdificioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF008CFF), // fondo azul claro
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Martes 1/04/2025',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
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
              itemCount: 8, // Puedes reemplazar con tu lista real
              itemBuilder: (context, index) {
                return const AsistenciaItem();
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
                onTap: () {
                  // Acción de agregar
                },
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
                  onTap: () {
                    // Acción de guardar
                  },
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

class AsistenciaItem extends StatelessWidget {
  const AsistenciaItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // Nombre
          Expanded(
            flex: 3,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blueGrey, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.red, width: 1), // Borde rojo
              ),
              alignment: Alignment.center,
              child: const Text(
                'Nombre',
                style: TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Icono presente
          const Icon(Icons.check_circle, color: Colors.green, size: 24),
          const SizedBox(width: 8),

          // Campo de hora
          Expanded(
            flex: 2,
            child: Container(
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red, width: 1), // Borde rojo
              ),
              child: const Text('.....', style: TextStyle(fontSize: 14)),
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
            onPressed: () {
              // Acción editar
            },
          ),

          // Eliminar
          IconButton(
            icon: Image.asset(
              'assets/images/borrar-usuario.png',
              width: 23,
              height: 23,
            ),
            onPressed: () {
              // Acción eliminar
            },
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable con animación de escala al presionar
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
