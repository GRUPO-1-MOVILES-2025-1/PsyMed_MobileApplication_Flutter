import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {

  static const String baseUrl = 'http://localhost:5236';


  static Future<List<Task>> getAllTasks() async {
    print('Haciendo petición GET a: $baseUrl/api/tasks');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tasks'),
        headers: {'Content-Type': 'application/json'},
      );

      print(' Respuesta HTTP: ${response.statusCode}');
      print(' Cuerpo de respuesta: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print(' JSON parseado: $jsonList');

        final tasks = jsonList.map((json) => Task.fromJson(json)).toList();
        print('Tareas convertidas: ${tasks.length}');

        return tasks;
      } else {
        print(' Error HTTP: ${response.statusCode} - ${response.body}');
        throw Exception('Error al obtener tareas: ${response.statusCode}');
      }
    } catch (e) {
      print(' Excepción en getAllTasks: $e');
      throw Exception('Error de conexión: $e');
    }
  }


  static Future<List<Task>> getTasksByPatient(int patientId) async {
    try {
      final allTasks = await getAllTasks();
      return allTasks.where((task) => task.idPatient == patientId).toList();
    } catch (e) {
      throw Exception('Error al obtener tareas del paciente: $e');
    }
  }


  static Future<Task?> getTaskById(String id) async {
    print('Buscando tarea por ID: $id');
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print(' Respuesta GET by ID: ${response.statusCode}');
      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Error al obtener tarea: ${response.statusCode}');
      }
    } catch (e) {
      print(' Error en getTaskById: $e');
      throw Exception('Error de conexión: $e');
    }
  }


  static Future<Task> createTask(CreateTaskRequest request) async {
    print('Creando tarea: ${request.toJson()}');
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print(' Respuesta POST: ${response.statusCode}');
      print(' Cuerpo respuesta POST: ${response.body}');

      if (response.statusCode == 201) {
        final createdTask = Task.fromJson(jsonDecode(response.body));
        print(' Tarea creada exitosamente: ${createdTask.id}');
        return createdTask;
      } else {
        print(' Error al crear tarea: ${response.statusCode} - ${response.body}');
        throw Exception('Error al crear tarea: ${response.statusCode}');
      }
    } catch (e) {
      print(' Excepción en createTask: $e');
      throw Exception('Error de conexión: $e');
    }
  }


  static Future<Task> updateTask(String id, UpdateTaskRequest request) async {
    print(' Actualizando tarea $id: ${request.toJson()}');
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(request.toJson()),
      );

      print(' Respuesta PUT: ${response.statusCode}');

      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Tarea no encontrada');
      } else {
        throw Exception('Error al actualizar tarea: ${response.statusCode}');
      }
    } catch (e) {
      print(' Error en updateTask: $e');
      throw Exception('Error de conexión: $e');
    }
  }

  static Future<bool> deleteTask(String id) async {
    print(' Eliminando tarea: $id');
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      print(' Respuesta DELETE: ${response.statusCode}');

      if (response.statusCode == 204) {
        return true;
      } else if (response.statusCode == 404) {
        return false;
      } else {
        throw Exception('Error al eliminar tarea: ${response.statusCode}');
      }
    } catch (e) {
      print(' Error en deleteTask: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}
