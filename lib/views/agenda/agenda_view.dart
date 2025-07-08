import 'package:flutter/material.dart';
import 'package:proyecto_moviles/shared/sidebar_widget.dart';
import 'package:proyecto_moviles/views/profile_view.dart';
import 'package:proyecto_moviles/services/cita_service.dart';
import 'package:proyecto_moviles/models/cita_medica.dart';

class AgendaView extends StatefulWidget {
  final String userName;
  final String userId;
  final String token;

  const AgendaView({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  State<AgendaView> createState() => _AgendaViewState();
}

class _AgendaViewState extends State<AgendaView> {
  

  final TextEditingController searchController = TextEditingController();
  List<CitaMedica> citas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCitas();
  }

  Future<void> _loadCitas() async {
    try {
      final id = int.tryParse(widget.userId);
      if (id != null) {
        final result = await CitaService().getCitasByMedico(id);
        setState(() {
          citas = result;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error al cargar citas: $e");
    }
  }

  void mostrarFormularioNuevaCita() {
  final _formKey = GlobalKey<FormState>();
  final pacienteCtrl = TextEditingController();
  final fechaCtrl = TextEditingController();
  final inicioCtrl = TextEditingController();
  final finCtrl = TextEditingController();
  bool importante = false;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Nueva Consulta'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: pacienteCtrl,
                  decoration: const InputDecoration(labelText: 'ID del Paciente'),
                  validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: fechaCtrl,
                  decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
                  validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: inicioCtrl,
                  decoration: const InputDecoration(labelText: 'Hora de Inicio (HH:mm)'),
                  validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: finCtrl,
                  decoration: const InputDecoration(labelText: 'Hora de Fin (HH:mm)'),
                  validator: (value) => value == null || value.isEmpty ? 'Requerido' : null,
                ),
                const SizedBox(height: 10),
                CheckboxListTile(
                  value: importante,
                  onChanged: (val) {
                    setState(() {
                      importante = val ?? false;
                    });
                  },
                  title: const Text('¿Es importante?'),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Guardar'),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final nueva = CitaMedica(
                  patientId: pacienteCtrl.text,
                  date: fechaCtrl.text,
                  startTime: inicioCtrl.text,
                  endTime: finCtrl.text,
                  important: importante,
                  medicoId: int.parse(widget.userId),
                );

                await CitaService().createCita(nueva);
                if (mounted) {
                  Navigator.pop(context); // cerrar el diálogo
                  _loadCitas(); // refrescar lista
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Cita registrada')),
                  );
                }
              }
            },
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    final filtered = citas
        .where((appt) => appt.patientId
            .toLowerCase()
            .contains(searchController.text.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SidebarWidget(
        userName: widget.userName,
        userId: widget.userId,
        token: widget.token,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 16),

            // Título
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Calendario de Citas',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Campo de búsqueda
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF4EFE9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    hintText: 'Buscar',
                    prefixIcon: Icon(Icons.search, color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Lista de citas
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final appt = filtered[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4EFE9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.calendar_today, color: Colors.black87),
                      ),
                      title: Text(
                        'Paciente: ${appt.patientId}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('${appt.date}   ${appt.startTime}–${appt.endTime}'),
                      trailing: appt.important
                          ? const Icon(Icons.star, color: Colors.amber)
                          : const Icon(Icons.star_border),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Botones inferiores
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                children: [
                  _buildGreenButton('New Consultation', Icons.add, mostrarFormularioNuevaCita),


                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGreenButton('Send recordatory', Icons.notifications, () {}),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildGreenButton('Modify schedule', Icons.edit_calendar, () {}),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreenButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1C9E7D),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }


  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF10BEAE),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menú',
            ),
          ),
          const Text(
            'PSYMED',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
