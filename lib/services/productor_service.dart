import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appcoffee/models/productor_model.dart';

class ProductorService {
  final String _baseUrl = 'http://10.0.2.2:3000'; // URL del servidor

  // Obtener todos los productores
  Future<List<Productor>> fetchProductores() async {
    final response = await http.get(Uri.parse('$_baseUrl/productores'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Productor.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener productores');
    }
  }

  // Obtener un productor por ID
  Future<Productor> fetchProductorById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/productores/$id'));
    if (response.statusCode == 200) {
      return Productor.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al obtener productor');
    }
  }

  // Crear un nuevo productor con o sin imagen en base64
  Future<void> createProductor(Productor productor) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/productores'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productor.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear productor');
    }
  }

  // Actualizar un productor existente con o sin imagen en base64
  Future<void> updateProductor(String id, Productor productor) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/productores/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(productor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar productor');
    }
  }

  // Eliminar un productor
  Future<void> deleteProductor(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/productores/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar productor');
    }
  }
}
