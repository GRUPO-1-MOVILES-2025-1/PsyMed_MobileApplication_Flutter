import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';
import '../request/create_task_request.dart';
import '../request/update_task_request.dart';

class EditMedicationView extends StatefulWidget {
  final Task? task;
  final bool isEditing;
  final VoidCallback? onTaskUpdated;

  const EditMedicationView({
    super.key,
    this.task,
    this.isEditing = true,
    this.onTaskUpdated,
  });

  @override
  State<EditMedicationView> createState() => _EditMedicationViewState();
}

class _EditMedicationViewState extends State<EditMedicationView> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _patientIdController;
  int _selectedStatus = 0;
  bool _isLoading = false;

  final List<String> _statusOptions = [
    'Pendiente',
    'En Progreso',
    'Completada',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController = TextEditingController(text: widget.task?.description ?? '');
    _patientIdController = TextEditingController(text: widget.task?.idPatient.toString() ?? '1');
    _selectedStatus = widget.task?.status ?? 0;

    print('🎬 EditMedicationView iniciado. Modo: ${widget.isEditing ? "Editar" : "Crear"}'); // Debug
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _patientIdController.dispose();
    super.dispose();
  }

  Future<void> _saveTask() async {
    print(' Intentando guardar tarea...'); // Debug

    if (_titleController.text.trim().isEmpty ||
        _descriptionController.text.trim().isEmpty ||
        _patientIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final patientId = int.tryParse(_patientIdController.text.trim());
    if (patientId == null || patientId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID del paciente debe ser un número válido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.isEditing && widget.task != null) {
        print(' Actualizando tarea existente: ${widget.task!.idPatient}'); // Debug

        final updateRequest = UpdateTaskRequest(

          idPatient: patientId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          status: _selectedStatus,
          startDate: DateTime.now().toIso8601String(),
        );

        final updatedTask = await TaskService.updateTask(widget.task!.idPatient, updateRequest);
        print('Tarea actualizada: ${updatedTask.idPatient}'); // Debug

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarea actualizada exitosamente'),
              backgroundColor: Color(0xFF10BEAE),
            ),
          );
        }
      } else {
        print(' Creando nueva tarea...'); // Debug

        final createRequest = CreateTaskRequest(
          idPatient: patientId,
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          status: _selectedStatus,
          startDate: widget.task!.startDate, // ➤ Usa el existente
        );

        final createdTask = await TaskService.createTask(createRequest);
        print(' Tarea creada: ${createdTask.idPatient}'); // Debug

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tarea creada exitosamente'),
              backgroundColor: Color(0xFF10BEAE),
            ),
          );
        }
      }


      print(' Llamando callback onTaskUpdated...'); // Debug
      if (widget.onTaskUpdated != null) {
        widget.onTaskUpdated!();
      }


      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        print(' Cerrando pantalla con resultado true');
        Navigator.pop(context, true);
      }
    } catch (e) {
      print(' Error al guardar tarea: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF10BEAE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            print(' Cerrando sin guardar'); // Debug
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.isEditing ? 'Editar Tarea' : 'Nueva Tarea',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF10BEAE).withOpacity(0.3),
            ),
            child: Column(
              children: [
                if (widget.isEditing && widget.task != null) ...[
                  const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Editando: ${widget.task!.title}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Estado actual: ${widget.task!.statusText}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ] else ...[
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Crear Nueva Tarea',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Completa los detalles a continuación',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),


          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isEditing) ...[
                    const Text(
                      'ID del Paciente',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _patientIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Ingresa el ID del paciente',
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFF10BEAE)),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Text(
                    'Título de la Tarea',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Ingresa el título de la tarea',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF10BEAE)),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Descripción',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Ingresa la descripción de la tarea',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF10BEAE)),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Estado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF10BEAE)),
                      ),
                      contentPadding: const EdgeInsets.all(16),
                    ),
                    items: _statusOptions.asMap().entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value ?? 0;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () {
                  print('💾 Botón guardar presionado'); // Debug
                  _saveTask();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10BEAE),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  widget.isEditing ? 'Guardar Cambios' : 'Crear Tarea',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
