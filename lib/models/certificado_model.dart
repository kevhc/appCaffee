class Certificado {
  final String id;
  final String certificado;
  final DateTime fecha;
  final int estado;

  Certificado({
    required this.id,
    required this.certificado,
    required this.fecha,
    required this.estado,
  });

  factory Certificado.fromJson(Map<String, dynamic> json) {
    return Certificado(
      id: json['_id'],
      certificado: json['certificado'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'certificado': certificado,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
    };
  }
}
