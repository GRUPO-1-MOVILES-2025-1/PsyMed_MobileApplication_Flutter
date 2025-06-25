import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/ task_service.dart';

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
  late TextEditingController _medicationNameController;
  late TextEditingController _dosageController;
  late TextEditingController _quantityController;
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  late TextEditingController _patientIdController;
  int _selectedStatus = 0;
  bool _isLoading = false;
  DateTime? _startDate;
  DateTime? _endDate;

  final List<String> _statusOptions = [
    'Active',
    'Paused',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    _patientIdController = TextEditingController(text: widget.task?.idPatient.toString() ?? '1');
    _selectedStatus = widget.task?.status ?? 0;


    if (widget.isEditing && widget.task != null) {
      _parseExistingDescription();
    } else {

      _medicationNameController = TextEditingController();
      _dosageController = TextEditingController();
      _quantityController = TextEditingController();
      _startDateController = TextEditingController();
      _endDateController = TextEditingController();
    }

    print('🎬 EditMedicationView iniciado. Modo: ${widget.isEditing ? "Editar" : "Crear"}');
  }

  void _parseExistingDescription() {
    // Intentar extraer información de la descripción existente
    // Formato esperado: "Dosage: [dosage] | Quantity: [quantity] | Start: [start] | End: [end]"
    String description = widget.task?.description ?? '';
    String medicationName = widget.task?.title ?? '';


    String dosage = '';
    String quantity = '';
    String startDate = '';
    String endDate = '';


    if (description.contains('|')) {
      List<String> parts = description.split('|');
      for (String part in parts) {
        part = part.trim();
        if (part.startsWith('Dosage:')) {
          dosage = part.substring(7).trim();
        } else if (part.startsWith('Quantity:')) {
          quantity = part.substring(9).trim();
        } else if (part.startsWith('Start:')) {
          startDate = part.substring(6).trim();
        } else if (part.startsWith('End:')) {
          endDate = part.substring(4).trim();
        }
      }
    } else {

      dosage = description;
    }

    _medicationNameController = TextEditingController(text: medicationName);
    _dosageController = TextEditingController(text: dosage);
    _quantityController = TextEditingController(text: quantity);
    _startDateController = TextEditingController(text: startDate);
    _endDateController = TextEditingController(text: endDate);


    if (startDate.isNotEmpty) {
      try {
        _startDate = DateTime.parse(startDate);
      } catch (e) {
        print('Error parsing start date: $e');
      }
    }
    if (endDate.isNotEmpty) {
      try {
        _endDate = DateTime.parse(endDate);
      } catch (e) {
        print('Error parsing end date: $e');
      }
    }
  }

  @override
  void dispose() {
    _medicationNameController.dispose();
    _dosageController.dispose();
    _quantityController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _patientIdController.dispose();
    super.dispose();
  }

  String _buildStructuredDescription() {

    List<String> parts = [];

    if (_dosageController.text.trim().isNotEmpty) {
      parts.add('Dosage: ${_dosageController.text.trim()}');
    }
    if (_quantityController.text.trim().isNotEmpty) {
      parts.add('Quantity: ${_quantityController.text.trim()}');
    }
    if (_startDateController.text.trim().isNotEmpty) {
      parts.add('Start: ${_startDateController.text.trim()}');
    }
    if (_endDateController.text.trim().isNotEmpty) {
      parts.add('End: ${_endDateController.text.trim()}');
    }

    return parts.join(' | ');
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF10BEAE),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _startDateController.text = "${picked.month}/${picked.day}/${picked.year}";
        } else {
          _endDate = picked;
          _endDateController.text = "${picked.month}/${picked.day}/${picked.year}";
        }
      });
    }
  }

  Future<void> _saveTask() async {
    print('Intentando guardar medicamento...');

    if (_medicationNameController.text.trim().isEmpty ||
        _patientIdController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete at least the medication name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final patientId = int.tryParse(_patientIdController.text.trim());
    if (patientId == null || patientId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Patient ID must be a valid number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final structuredDescription = _buildStructuredDescription();

      if (widget.isEditing && widget.task != null) {
        print('Actualizando medicamento existente: ${widget.task!.id}');

        final updateRequest = UpdateTaskRequest(
          title: _medicationNameController.text.trim(),
          description: structuredDescription,
          status: _selectedStatus,
        );

        final updatedTask = await TaskService.updateTask(widget.task!.id, updateRequest);
        print(' Medicamento actualizado: ${updatedTask.id}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medication updated successfully'),
              backgroundColor: Color(0xFF10BEAE),
            ),
          );
        }
      } else {
        print(' Creando nuevo medicamento...');

        final createRequest = CreateTaskRequest(
          idPatient: patientId,
          title: _medicationNameController.text.trim(),
          description: structuredDescription,
          status: _selectedStatus,
        );

        final createdTask = await TaskService.createTask(createRequest);
        print(' Medicamento creado: ${createdTask.id}');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Medication created successfully'),
              backgroundColor: Color(0xFF10BEAE),
            ),
          );
        }
      }

      print(' Llamando callback onTaskUpdated...');
      if (widget.onTaskUpdated != null) {
        widget.onTaskUpdated!();
      }

      await Future.delayed(const Duration(milliseconds: 1000));

      if (mounted) {
        print(' Cerrando pantalla con resultado true');
        Navigator.pop(context, true);
      }
    } catch (e) {
      print(' Error al guardar medicamento: $e');
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF10BEAE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            print(' Cerrando sin guardar');
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'PSYMED',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [

          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF10BEAE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medication Name: ${_medicationNameController.text.isNotEmpty ? _medicationNameController.text : 'Enter medication name'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dosage/Frequency: ${_dosageController.text.isNotEmpty ? _dosageController.text : 'Enter dosage'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quantity: ${_quantityController.text.isNotEmpty ? _quantityController.text : 'Enter quantity'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Start Date: ${_startDateController.text.isNotEmpty ? _startDateController.text : 'Select start date'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'End Date: ${_endDateController.text.isNotEmpty ? _endDateController.text : 'Select end date'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
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
                      'Patient ID',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _patientIdController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Enter patient ID',
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
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Text(
                    'Medication Name',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      hintText: 'Enter medication name',
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
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Dosage/Frequency',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _dosageController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 0.5 mg, Twice daily',
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
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      hintText: 'e.g., 60 tablets',
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
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Start Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, true),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _startDateController,
                        decoration: InputDecoration(
                          hintText: 'Select start date',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF10BEAE)),
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
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'End Date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _selectDate(context, false),
                    child: IgnorePointer(
                      child: TextFormField(
                        controller: _endDateController,
                        decoration: InputDecoration(
                          hintText: 'Select end date',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          suffixIcon: const Icon(Icons.calendar_today, color: Color(0xFF10BEAE)),
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
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Status',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
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
                      filled: true,
                      fillColor: Colors.white,
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
                  print('Botón guardar presionado');
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
                    : const Text(
                  'Save',
                  style: TextStyle(
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
