import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final String _baseUrl =
      'http://10.0.2.2:3000/auth'; // Cambia esto a la URL de tu servidor

  Future<bool> login(String usuario, String clave) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'usuario': usuario, 'clave': clave}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Para depuración

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          return true;
        }
      }
    } catch (e) {
      print('Error during login: $e');
    }
    return false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<int?> getUserRole() async {
    final token = await getToken();
    if (token != null) {
      try {
        final decodedToken = JwtDecoder.decode(token);
        return decodedToken['rol'];
      } catch (e) {
        print('Error decoding token: $e');
      }
    }
    return null;
  }
}
