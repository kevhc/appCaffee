import 'package:flutter/material.dart';
import '../models/certificado_model.dart';
import '../services/certificado_service.dart';

class CertificadoController {
  final CertificadoService _service = CertificadoService();

  Future<List<Certificado>> fetchCertificados() async {
    return await _service.fetchCertificados();
  }

  Future<void> createCertificado(Certificado certificado) async {
    await _service.createCertificado(certificado);
  }

  Future<void> updateCertificado(String id, Certificado certificado) async {
    await _service.updateCertificado(id, certificado);
  }

  Future<void> deleteCertificado(String id) async {
    await _service.deleteCertificado(id);
  }
}
