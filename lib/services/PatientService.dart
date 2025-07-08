import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/patient.dart';


class PatientService {
  static const String baseUrl = 'http://192.168.31.252:5236/api';

  // Método GET: Obtener todos los pacientes
  static Future<List<Patient>> fetchPatients({String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/patients'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Patient.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener pacientes: ${response.statusCode}');
    }
  }

  // Método POST: Crear un nuevo paciente
  static Future<Patient> createPatient({
    required Patient patient,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/patients'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return Patient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear paciente: ${response.body}');
    }
  }
}
