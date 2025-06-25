import 'package:flutter/material.dart';

class HistorialNotasView extends StatelessWidget {
  final String nombrePaciente;
  final String doctorAsignado;
  final List<String> notasClinicas;
  final List<String> tratamientos;

  const HistorialNotasView({
    super.key,
    this.nombrePaciente = 'Pedra Pabla',
    this.doctorAsignado = 'Doctor 1',
    this.notasClinicas = const ['Dato 1', 'Dato 2', 'Dato 3'],
    this.tratamientos = const ['Diagnostico', 'Datos Fisiológicos', 'Estados de ánimo', 'Tareas asignadas'],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BB1A2),
        title: const Text(
          'PSYMED',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: const Icon(Icons.menu),
        actions: const [Icon(Icons.settings)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFFF0E9F9),
              // image de ejemplo omitida
            ),
            const SizedBox(height: 16),
            Text(
              'Paciente',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              nombrePaciente,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Doctor: $doctorAsignado',
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            _seccionNotas(
              icono: Icons.edit_note,
              titulo: 'Notas Clínicas',
              items: notasClinicas,
            ),
            const SizedBox(height: 16),
            _seccionNotas(
              icono: Icons.medical_services_outlined,
              titulo: 'Tratamientos',
              items: tratamientos,
            ),
          ],
        ),
      ),
    );
  }

  Widget _seccionNotas({
    required IconData icono,
    required String titulo,
    required List<String> items,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F0E7),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icono, color: Colors.brown),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              ...items.map((nota) => Row(
                children: [
                  const Text('• ', style: TextStyle(color: Colors.brown)),
                  Flexible(
                    child: Text(nota, style: const TextStyle(color: Colors.brown)),
                  ),
                ],
              )),
            ],
          ),
        ),
      ],
    );
  }
}