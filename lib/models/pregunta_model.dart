class Pregunta {
  final String id;
  final String pregunta;
  final DateTime fecha;
  final int estado;

  Pregunta({
    required this.id,
    required this.pregunta,
    required this.fecha,
    required this.estado,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      id: json['_id'],
      pregunta: json['pregunta'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pregunta': pregunta,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
    };
  }
}
