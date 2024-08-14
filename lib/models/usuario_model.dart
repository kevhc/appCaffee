class Usuario {
  final String id;
  final String nombre;
  final String apellido;
  final String email;
  final String usuario;
  final String clave;
  final String? foto;
  final DateTime fecha;
  final DateTime ultimaConexion;
  final int estado;
  final int rol;

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
      fecha: DateTime.parse(json['fecha']),
      ultimaConexion: DateTime.parse(json['ultima_conexion']),
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
      'foto': foto,
      'fecha': fecha.toIso8601String(),
      'ultima_conexion': ultimaConexion.toIso8601String(),
      'estado': estado,
      'rol': rol,
    };
  }
}
