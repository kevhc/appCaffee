import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appcoffee/models/usuario_model.dart';

class UsuarioService {
  final String _baseUrl =
      'http://10.0.2.2:3000/usuarios'; // Cambia esto a la URL de tu servidor

  Future<bool> createUsuario(Map<String, dynamic> usuarioData) async {
    try {
      final token = await _getAuthToken();
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(usuarioData),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        print('Failed to create user: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during user creation: $e');
    }
    return false;
  }

  Future<bool> updateUsuario(
      String id, Map<String, dynamic> usuarioData) async {
    try {
      final token = await _getAuthToken();
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(usuarioData),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to update user: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during user update: $e');
    }
    return false;
  }

  Future<bool> deleteUsuario(String id) async {
    try {
      final token = await _getAuthToken();
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to delete user: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during user deletion: $e');
    }
    return false;
  }

  Future<Map<String, dynamic>?> getUsuario(String id) async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to fetch user: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during fetching user: $e');
    }
    return null;
  }

  Future<String> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Future<List<Usuario>> fetchUsuarios() async {
    try {
      final token = await _getAuthToken();
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Usuario.fromJson(json)).toList();
      } else {
        print('Failed to fetch users: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error during fetching users: $e');
    }
    return [];
  }
}
