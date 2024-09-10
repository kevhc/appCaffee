class Productor {
  final String id;
  final String nombre;
  final String apellido;
  final int dni; // Cambiado a String para mayor flexibilidad
  final String sexo;
  final String caserio;
  final String distrito;
  final String provincia;
  final String region;
  final String estatus;
  final int telefono; // Cambiado a String para mayor flexibilidad
  final String? longitud;
  final String? latitud;
  final String? altitud;
  final String? foto; // Foto es opcional ahora
  final DateTime fecha;
  final int estado;

  Productor({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.sexo,
    required this.caserio,
    required this.distrito,
    required this.provincia,
    required this.region,
    required this.estatus,
    required this.telefono,
    this.longitud,
    this.latitud,
    this.altitud,
    this.foto,
    required this.fecha,
    required this.estado,
  });

  factory Productor.fromJson(Map<String, dynamic> json) {
    return Productor(
      id: json['_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      dni: json['dni'],
      sexo: json['sexo'],
      caserio: json['caserio'],
      distrito: json['distrito'],
      provincia: json['provincia'],
      region: json['region'],
      estatus: json['estatus'],
      telefono: json['telefono'],
      longitud: json['longitud'],
      latitud: json['latitud'],
      altitud: json['altitud'],
      foto: json['foto'],
      fecha: DateTime.parse(json['fecha']),
      estado: json['estado'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'sexo': sexo,
      'caserio': caserio,
      'distrito': distrito,
      'provincia': provincia,
      'region': region,
      'estatus': estatus,
      'telefono': telefono,
      'longitud': longitud,
      'latitud': latitud,
      'altitud': altitud,
      'foto': foto,
      'fecha': fecha.toIso8601String(),
      'estado': estado,
    };
  }

  Productor copyWith({
    String? id,
    String? nombre,
    String? apellido,
    int? dni, // Cambiado a String
    String? sexo,
    String? caserio,
    String? distrito,
    String? provincia,
    String? region,
    String? estatus,
    int? telefono, // Cambiado a String
    String? longitud,
    String? latitud,
    String? altitud,
    String? foto, // Foto es opcional
    DateTime? fecha,
    int? estado,
  }) {
    return Productor(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      dni: dni ?? this.dni,
      sexo: sexo ?? this.sexo,
      caserio: caserio ?? this.caserio,
      distrito: distrito ?? this.distrito,
      provincia: provincia ?? this.provincia,
      region: region ?? this.region,
      estatus: estatus ?? this.estatus,
      telefono: telefono ?? this.telefono,
      longitud: longitud ?? this.longitud,
      latitud: latitud ?? this.latitud,
      altitud: altitud ?? this.altitud,
      foto: foto ?? this.foto,
      fecha: fecha ?? this.fecha,
      estado: estado ?? this.estado,
    );
  }
}
