// lib/services/parcela_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appcoffee/models/parcela_model.dart';

class ParcelaService {
  final String _baseUrl =
      'http://10.0.2.2:3000'; // Cambia esto a la URL de tu servidor

  Future<List<Parcela>> fetchParcelas() async {
    final response = await http.get(Uri.parse('$_baseUrl/parcelas'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Parcela.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar parcelas');
    }
  }

  Future<void> createParcela(Parcela parcela) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/parcelas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(parcela.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear parcela');
    }
  }

  Future<void> updateParcela(String id, Parcela parcela) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/parcelas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(parcela.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar parcela');
    }
  }

  Future<void> deleteParcela(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/parcelas/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar parcela');
    }
  }
}
