import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // 🔧 Cambia esta IP si corres en emulador físico o dispositivo real
  static const String baseUrl = 'http://localhost:5236'; // o tu IP local

  /// Registro de usuario
  static Future<http.Response> register({
    required String username,
    required String name,
    required String lastName,
    required DateTime birthDate,
    required String email,
    required String gender,
    required String phone,
    required String ubication,
    required String password,
  }) {
    final Map<String, dynamic> userData = {
      'username': username,
      'name': name,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
      'gender': gender,
      'phone': phone,
      'ubication': ubication,
      'password': password,
    };

    return http.post(
      Uri.parse('$baseUrl/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
  }

  /// Inicio de sesión
  static Future<http.Response> login({
    required String username,
    required String password,
  }) {
    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password,
    };

    return http.post(
      Uri.parse('$baseUrl/api/Auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginData),
    );
  }
  
}
