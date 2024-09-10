import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:appcoffee/models/productor_model.dart';
import 'package:appcoffee/services/productor_service.dart';

class ProductorController {
  final ProductorService _productorService = ProductorService();
  final ImagePicker _picker = ImagePicker();
  final String defaultImagePath = 'assets/icons/icon_user.png';

  // Obtener todos los productores
  Future<List<Productor>> fetchProductores() async {
    return await _productorService.fetchProductores();
  }

  // Obtener un productor por ID
  Future<Productor> fetchProductorById(String id) async {
    return await _productorService.fetchProductorById(id);
  }

  // Convertir la imagen a base64
  Future<String?> convertImageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error al convertir la imagen a base64: $e');
      return null;
    }
  }

  // Convertir la imagen predeterminada a base64
  Future<String?> convertDefaultImageToBase64() async {
    try {
      final byteData = await rootBundle.load(defaultImagePath);
      final bytes = byteData.buffer.asUint8List();
      return base64Encode(bytes);
    } catch (e) {
      print('Error al convertir la imagen predeterminada a base64: $e');
      return null;
    }
  }

  // Crear un nuevo productor, opcionalmente con una imagen
  Future<void> createProductor(Productor productor, {File? image}) async {
    if (image != null) {
      String? imageBase64 = await convertImageToBase64(image);
      if (imageBase64 != null) {
        productor = productor.copyWith(foto: imageBase64);
      }
    } else {
      // Asignar la imagen predeterminada si no se proporciona ninguna
      String? defaultImageBase64 = await convertDefaultImageToBase64();
      if (defaultImageBase64 != null) {
        productor = productor.copyWith(foto: defaultImageBase64);
      }
    }
    await _productorService.createProductor(productor);
  }

  // Actualizar un productor existente, opcionalmente con una nueva imagen
  Future<void> updateProductor(String id, Productor productor,
      {File? image}) async {
    if (image != null) {
      String? imageBase64 = await convertImageToBase64(image);
      if (imageBase64 != null) {
        productor = productor.copyWith(foto: imageBase64);
      }
    } else {
      // Asignar la imagen predeterminada si no se proporciona ninguna
      String? defaultImageBase64 = await convertDefaultImageToBase64();
      if (defaultImageBase64 != null) {
        productor = productor.copyWith(foto: defaultImageBase64);
      }
    }
    await _productorService.updateProductor(id, productor);
  }

  // Eliminar un productor
  Future<void> deleteProductor(String id) async {
    await _productorService.deleteProductor(id);
  }

  // Seleccionar una imagen desde la galería o la cámara
  Future<File?> pickImage({required bool fromGallery}) async {
    final pickedFile = await _picker.pickImage(
      source: fromGallery ? ImageSource.gallery : ImageSource.camera,
    );
    return pickedFile != null ? File(pickedFile.path) : null;
  }
}
