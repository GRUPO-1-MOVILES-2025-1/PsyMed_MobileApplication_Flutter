import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';

class ProfileService {
  static const String baseUrl = 'http://10.0.2.2:5236/api/v1/Profiles'; // si usas emulador

  /// Obtener profile por ID
  static Future<ProfileModel?> getProfileById(int profileId) async {
    final response = await http.get(Uri.parse('$baseUrl/$profileId'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ProfileModel.fromJson(json);
    } else {
      print('Error al obtener el perfil: ${response.statusCode}');
      return null;
    }
  }

  /// Actualizar profile
  static Future<bool> updateProfile(ProfileModel profile) async {
    final body = {
      'id': profile.id,
      'email': profile.email,
      'weight': profile.weight,
      'height': profile.height,
      'phone': profile.phone,
    };

    final response = await http.put(
      Uri.parse('$baseUrl/${profile.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error al actualizar el perfil: ${response.statusCode}');
      return false;
    }
  }
}