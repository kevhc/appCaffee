// lib/services/pregunta_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appcoffee/models/pregunta_model.dart';

class PreguntaService {
  final String _baseUrl =
      'http://10.0.2.2:3000'; // Cambia esto a la URL de tu servidor

  // Método para obtener todas las preguntas
  Future<List<Pregunta>> fetchPreguntas() async {
    final response = await http.get(Uri.parse('$_baseUrl/preguntas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Pregunta.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar preguntas');
    }
  }

  // Método para crear una nueva pregunta
  Future<void> createPregunta(Pregunta pregunta) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/preguntas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pregunta.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear pregunta');
    }
  }

  // Método para actualizar una pregunta existente
  Future<void> updatePregunta(String id, Pregunta pregunta) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/preguntas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pregunta.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar pregunta');
    }
  }

  // Método para eliminar una pregunta
  Future<void> deletePregunta(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/preguntas/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar pregunta');
    }
  }
}
