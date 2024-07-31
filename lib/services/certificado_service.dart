// lib/services/certificado_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:appcoffee/models/certificado_model.dart';

class CertificadoService {
  final String _baseUrl =
      'http://10.0.2.2:3000'; // Cambia esto a la URL de tu servidor

  Future<List<Certificado>> fetchCertificados() async {
    final response = await http.get(Uri.parse('$_baseUrl/certificados'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Certificado.fromJson(item)).toList();
    } else {
      throw Exception('Error al cargar certificados');
    }
  }

  Future<void> createCertificado(Certificado certificado) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/certificados'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(certificado.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear certificado');
    }
  }

  Future<void> updateCertificado(String id, Certificado certificado) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/certificados/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(certificado.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar certificado');
    }
  }

  Future<void> deleteCertificado(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/certificados/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar certificado');
    }
  }
}
