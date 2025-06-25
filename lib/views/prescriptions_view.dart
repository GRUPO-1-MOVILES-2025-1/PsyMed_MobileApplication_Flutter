import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/edit_medication_view.dart';
import '../services/ task_service.dart';
import '../models/task_model.dart';

class PrescriptionsView extends StatefulWidget {
  final String patientName;
  final String doctorName;

  const PrescriptionsView({
    super.key,
    required this.patientName,
    required this.doctorName,
  });

  @override
  State<PrescriptionsView> createState() => _PrescriptionsViewState();
}

class _PrescriptionsViewState extends State<PrescriptionsView> {
  List<Task> tasks = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    print('Cargando medicamentos...');
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final allTasks = await TaskService.getAllTasks();
      print('Medicamentos obtenidos: ${allTasks.length}');

      setState(() {
        tasks = allTasks;
        isLoading = false;
      });

      print('Estado actualizado. Total medicamentos en UI: ${tasks.length}');
    } catch (e) {
      print(' Error al cargar medicamentos: $e');
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteTask(String taskId) async {
    try {
      final success = await TaskService.deleteTask(taskId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Medication deleted successfully'),
            backgroundColor: Color(0xFF10BEAE),
          ),
        );
        await _loadTasks();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Medication not found'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Map<String, String> _parseDescription(String description) {
    Map<String, String> parsed = {
      'dosage': '',
      'quantity': '',
      'startDate': '',
      'endDate': '',
    };

    if (description.contains('|')) {
      List<String> parts = description.split('|');
      for (String part in parts) {
        part = part.trim();
        if (part.startsWith('Dosage:')) {
          parsed['dosage'] = part.substring(7).trim();
        } else if (part.startsWith('Quantity:')) {
          parsed['quantity'] = part.substring(9).trim();
        } else if (part.startsWith('Start:')) {
          parsed['startDate'] = part.substring(6).trim();
        } else if (part.startsWith('End:')) {
          parsed['endDate'] = part.substring(4).trim();
        }
      }
    } else {
      parsed['dosage'] = description;
    }

    return parsed;
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Active';
      case 1:
        return 'Paused';
      case 2:
        return 'Completed';
      default:
        return 'Unknown';
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PSYMED - Medications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              print(' Botón refresh presionado');
              _loadTasks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Patient Info Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Patient Medications',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.patientName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'Doctor: ${widget.doctorName}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          // Medications Section
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLoading
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Color(0xFF10BEAE)),
                    SizedBox(height: 16),
                    Text('Loading medications...'),
                  ],
                ),
              )
                  : errorMessage != null
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading medications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadTasks,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
                  : tasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.medication, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No medications available',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Press "Add Medication" to create one',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _loadTasks,
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final parsedDescription = _parseDescription(task.description);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10BEAE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Medication Name: ${task.title}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (parsedDescription['dosage']!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Dosage/Frequency: ${parsedDescription['dosage']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    if (parsedDescription['quantity']!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Quantity: ${parsedDescription['quantity']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    if (parsedDescription['startDate']!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'Start Date: ${parsedDescription['startDate']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    if (parsedDescription['endDate']!.isNotEmpty) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        'End Date: ${parsedDescription['endDate']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Status: ${_getStatusText(task.status)}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert, color: Colors.white),
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    _editTask(task);
                                  } else if (value == 'delete') {
                                    _showDeleteConfirmation(task);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 20),
                                        SizedBox(width: 8),
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete, size: 20, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Delete', style: TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditMedicationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Edit Medication',
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
                        onPressed: () {
                          print('Botón Add Medication presionado');
                          _addNewMedication();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Add Medication',
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showEditMedicationDialog(BuildContext context) {
    if (tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No medications to edit'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Medication to Edit'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: const Icon(Icons.medication, color: Color(0xFF10BEAE)),
                  title: Text(task.title),
                  subtitle: Text(_getStatusText(task.status)),
                  onTap: () {
                    Navigator.pop(context);
                    _editTask(task);
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) async {
    print('Editando medicamento: ${task.title}');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationView(
          task: task,
          isEditing: true,
          onTaskUpdated: () {
            print('Callback onTaskUpdated llamado desde edit');
            _loadTasks();
          },
        ),
      ),
    );

    print(' Resultado de edición: $result');
    if (result == true) {
      await _loadTasks();
    }
  }

  void _addNewMedication() async {
    print(' Navegando a crear nuevo medicamento');
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationView(
          task: null,
          isEditing: false,
          onTaskUpdated: () {
            print('Callback onTaskUpdated llamado desde create');
            _loadTasks();
          },
        ),
      ),
    );

    print('Resultado de creación: $result');
    if (result == true) {
      print('Recargando lista después de crear medicamento');
      await _loadTasks();
    }
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the medication "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask(task.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
