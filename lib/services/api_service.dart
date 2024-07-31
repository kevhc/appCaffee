import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String _baseUrl =
      'http://10.0.2.2:3000/auth'; // Cambia esto si es necesario

  Future<List<dynamic>> fetchUsers() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/users'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<Map<String, dynamic>> fetchUserById(String userId) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(updates),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(String userId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$_baseUrl/users/$userId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }
}
