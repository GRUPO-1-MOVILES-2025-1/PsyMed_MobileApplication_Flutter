import 'package:flutter/material.dart';
import 'package:proyecto_moviles/models/patient.dart';
import 'package:proyecto_moviles/services/PatientService.dart';
import 'package:proyecto_moviles/shared/sidebar_widget.dart';
import 'patient_detail_view.dart';

class PatientsListView extends StatefulWidget {
  final String userName;
  final String userId;
  final String token;

  const PatientsListView({
    super.key,
    required this.userName,
    required this.userId,
    required this.token,
  });

  @override
  State<PatientsListView> createState() => _PatientsListViewState();
}

class _PatientsListViewState extends State<PatientsListView> {
  List<Patient> _patients = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  void _fetchPatients() async {
    try {
      final patients = await PatientService.fetchPatients(token: widget.token);
      setState(() {
        _patients = patients;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _mostrarDialogoAgregarPaciente(BuildContext context) {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Agregar Paciente"),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: "Nombre"),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _ageController,
                  decoration: InputDecoration(labelText: "Edad"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: "Teléfono"),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: "Email"),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Requerido' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  final newPatient = Patient(
                    name: _nameController.text.trim(),
                    age: int.parse(_ageController.text.trim()),
                    phone: _phoneController.text.trim(),
                    email: _emailController.text.trim(),
                  );
                  await PatientService.createPatient(
                      patient: newPatient, token: widget.token);
                  Navigator.pop(context);
                  _fetchPatients();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Paciente agregado con éxito')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text("Guardar"),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: SidebarWidget(
        userName: widget.userName,
        userId: widget.userId,
        token: widget.token,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF10BEAE),
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Menú',
          ),
        ),
        title: Text(
          'Welcome ${widget.userName}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              if (_loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Expanded(
                  child: Center(child: Text('Error: $_error')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 64, 16, 16),
                    itemCount: _patients.length,
                    itemBuilder: (context, index) {
                      final patient = _patients[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[200],
                            child: Text(
                              patient.name[0],
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                          title: Text(
                            patient.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${patient.age} años',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '${patient.phone} | ${patient.email}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () {
                              // TODO: Implementar edición
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PatientDetailView(
                                  patientName: patient.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _mostrarDialogoAgregarPaciente(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Add Patient',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _fetchPatients,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Reload',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            left: 12,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              elevation: 2,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.black),
              tooltip: 'Volver',
            ),
          ),
        ],
      ),
    );
  }
}
