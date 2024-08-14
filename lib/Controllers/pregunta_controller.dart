// lib/controllers/pregunta_controller.dart

import 'package:flutter/material.dart';
import '../models/preguntas_model.dart';
import '../services/pregunta_service.dart';

class PreguntaController {
  final PreguntaService _service = PreguntaService();

  // Método para obtener la lista de preguntas
  Future<List<Pregunta>> fetchPreguntas() async {
    return await _service.fetchPreguntas();
  }

  // Método para crear una nueva pregunta
  Future<void> createPregunta(Pregunta pregunta) async {
    await _service.createPregunta(pregunta);
  }

  // Método para actualizar una pregunta existente
  Future<void> updatePregunta(String id, Pregunta pregunta) async {
    await _service.updatePregunta(id, pregunta);
  }

  // Método para eliminar una pregunta
  Future<void> deletePregunta(String id) async {
    await _service.deletePregunta(id);
  }
}
