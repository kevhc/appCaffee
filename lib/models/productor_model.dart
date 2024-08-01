class Productor {
  final String id;
  final String nombre;
  final String apellido;
  final int dni;
  final String sexo;
  final String caserio;
  final String distrito;
  final String provincia;
  final String region;
  final String estatus;
  final int telefono;
  final String longitud;
  final String latitud;
  final String altitud;
  final String foto;
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
    required this.longitud,
    required this.latitud,
    required this.altitud,
    required this.foto,
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
}
