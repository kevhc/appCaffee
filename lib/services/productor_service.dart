import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/productor_model.dart';

class ProductorService {
  final String baseUrl = 'http://10.0.2.2:3000'; // Cambia esto a tu URL de API

  // Método para obtener la lista de productores
  Future<List<Productor>> fetchProductores() async {
    final response = await http.get(Uri.parse('$baseUrl/productores'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Productor.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar productores');
    }
  }

  // Método para eliminar un productor
  Future<void> deleteProductor(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/productores/$id'));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar productor');
    }
  }

  // Método para crear un nuevo productor
  Future<void> createProductor(Productor productor, File? image) async {
    String? imagePath;

    if (image != null) {
      imagePath = await uploadImage(image);
    }

    final response = await http.post(
      Uri.parse('$baseUrl/productores'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        ...productor.toJson(),
        'foto': imagePath,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al crear productor');
    }
  }

  // Método para actualizar un productor existente
  Future<void> updateProductor(
      String id, Productor productor, File? image) async {
    String? imagePath;

    if (image != null) {
      imagePath = await uploadImage(image);
    }

    final response = await http.put(
      Uri.parse('$baseUrl/productores/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        ...productor.toJson(),
        'foto': imagePath,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar productor');
    }
  }

  // Método para subir una imagen
  Future<String> uploadImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/upload'),
    );

    request.files.add(
      http.MultipartFile(
        'file',
        image.readAsBytes().asStream(),
        image.lengthSync(),
        filename: image.uri.pathSegments.last,
        contentType:
            MediaType('image', 'jpeg'), // Ajusta según el tipo de imagen
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final filePath = json.decode(responseBody)['filePath'];
      return filePath;
    } else {
      throw Exception('Error al subir la imagen');
    }
  }
}
