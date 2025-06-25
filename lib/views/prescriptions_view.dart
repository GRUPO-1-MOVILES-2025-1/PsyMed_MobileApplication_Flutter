import 'package:flutter/material.dart';
import 'package:proyecto_moviles/views/edit_medication_view.dart';
import '../services/task_service.dart';
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
    print(' Cargando tareas...'); // Debug
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final allTasks = await TaskService.getAllTasks();
      print('📋 Tareas obtenidas: ${allTasks.length}'); // Debug

      // Imprimir cada tarea para debug
      for (var task in allTasks) {
        print(' Tarea: ${task.title} - Estado: ${task.status} - ID: ${task.idPatient}');
      }

      setState(() {
        tasks = allTasks;
        isLoading = false;
      });

      print(' Estado actualizado. Total tareas en UI: ${tasks.length}'); // Debug
    } catch (e) {
      print(' Error al cargar tareas: $e'); // Debug
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
            content: Text('Tarea eliminada exitosamente'),
            backgroundColor: Color(0xFF10BEAE),
          ),
        );
        await _loadTasks(); // Esperar a que termine la recarga
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error: Tarea no encontrada'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al eliminar: $e'),
          backgroundColor: Colors.red,
        ),
      );
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
          'PSYMED - Tareas',
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
              print(' Botón refresh presionado'); // Debug
              _loadTasks();
            },
          ),
        ],
      ),
      body: Column(
        children: [
 
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tareas del Paciente',
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
 
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Debug: ${tasks.length} tareas cargadas',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),


          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: isLoading
                  ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando tareas...'),
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
                      'Error al cargar tareas',
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
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
                  : tasks.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.task_alt, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    const Text(
                      'No hay tareas disponibles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Presiona "Nueva Tarea" para crear una',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        print(' Botón recargar desde empty state'); // Debug
                        _loadTasks();
                      },
                      child: const Text('Recargar'),
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
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getStatusColor(task.status),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              _getStatusIcon(task.status),
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tarea: ${task.title}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Descripción: ${task.description}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  'Estado: ${task.statusText}',
                                  style: TextStyle(
                                    color: _getStatusColor(task.status),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'ID: ${task.idPatient}', // Debug
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  'Creada: ${task.startDate}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
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
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Eliminar', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
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

       
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          _showEditTaskDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10BEAE),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Editar Tarea',
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
                          print(' Botón Nueva Tarea presionado'); // Debug
                          _addNewTask();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text(
                          'Nueva Tarea',
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

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.pending;
      case 1:
        return Icons.play_arrow;
      case 2:
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  void _showEditTaskDialog(BuildContext context) {
    if (tasks.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay tareas para editar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Tarea para Editar'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  leading: Icon(
                    _getStatusIcon(task.status),
                    color: _getStatusColor(task.status),
                  ),
                  title: Text(task.title),
                  subtitle: Text(task.statusText),
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
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _editTask(Task task) async {
    print(' Editando tarea: ${task.title}'); // Debug
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationView(
          task: task,
          isEditing: true,
          onTaskUpdated: () {
            print(' Callback onTaskUpdated llamado desde edit'); // Debug
            _loadTasks();
          },
        ),
      ),
    );

    print(' Resultado de edición: $result'); // Debug
    if (result == true) {
      await _loadTasks();
    }
  }

  void _addNewTask() async {
    print(' Navegando a crear nueva tarea'); // Debug
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMedicationView(
          task: null,
          isEditing: false,
          onTaskUpdated: () {
            print(' Callback onTaskUpdated llamado desde create'); // Debug
            _loadTasks();
          },
        ),
      ),
    );

    print(' Resultado de creación: $result'); // Debug
    if (result == true) {
      print('Recargando lista después de crear tarea'); // Debug
      await _loadTasks();
    }
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar la tarea "${task.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _deleteTask(task.idPatient);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
