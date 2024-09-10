class Usuario {
  String id;
  String nombre;
  String apellido;
  String email;
  String usuario;
  String clave;
  String? foto;
  String fecha;
  String ultimaConexion;
  int estado;
  int rol;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.usuario,
    required this.clave,
    this.foto,
    required this.fecha,
    required this.ultimaConexion,
    required this.estado,
    required this.rol,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      usuario: json['usuario'],
      clave: json['clave'],
      foto: json['foto'],
      fecha: json['fecha'],
      ultimaConexion: json['ultimaConexion'],
      estado: json['estado'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'usuario': usuario,
      'clave': clave,
      'foto': foto, // Manejo de null en la conversión a JSON
      'fecha': fecha,
      'ultimaConexion': ultimaConexion,
      'estado': estado,
      'rol': rol,
    };
  }

  Usuario copyWith({
    String? id,
    String? nombre,
    String? apellido,
    String? email,
    String? usuario,
    String? clave,
    String? foto,
    String? fecha,
    String? ultimaConexion,
    int? estado,
    int? rol,
  }) {
    return Usuario(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      email: email ?? this.email,
      usuario: usuario ?? this.usuario,
      clave: clave ?? this.clave,
      foto: foto ?? this.foto,
      fecha: fecha ?? this.fecha,
      ultimaConexion: ultimaConexion ?? this.ultimaConexion,
      estado: estado ?? this.estado,
      rol: rol ?? this.rol,
    );
  }
}
