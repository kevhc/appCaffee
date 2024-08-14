import 'package:flutter/material.dart';
import '../models/parcela_model.dart';
import '../services/parcela_service.dart';

class ParcelaController {
  final ParcelaService _service = ParcelaService();

  Future<List<Parcela>> fetchParcelas() async {
    return await _service.fetchParcelas();
  }

  Future<void> createParcela(Parcela parcela) async {
    await _service.createParcela(parcela);
  }

  Future<void> updateParcela(String id, Parcela parcela) async {
    await _service.updateParcela(id, parcela);
  }

  Future<void> deleteParcela(String id) async {
    await _service.deleteParcela(id);
  }
}
