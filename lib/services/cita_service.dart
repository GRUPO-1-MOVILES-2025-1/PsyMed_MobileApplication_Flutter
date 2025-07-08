import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cita_medica.dart';

class CitaService {
  final String baseUrl = 'http://192.168.31.252:5236/api/citas';

  Future<List<CitaMedica>> getCitasByMedico(int medicoId) async {
    final response = await http.get(Uri.parse('$baseUrl/medico/$medicoId'));
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((json) => CitaMedica.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar citas');
    }
  }

  Future<CitaMedica> createCita(CitaMedica cita) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(cita.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CitaMedica.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Error al crear cita');
    }
  }
}
