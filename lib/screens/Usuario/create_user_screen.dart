import 'package:flutter/material.dart';
import 'package:appcoffee/services/usuario_service.dart'; // Nuevo servicio para manejar usuarios
import 'package:appcoffee/models/usuario_model.dart'; // Modelo de Usuario

class CreateOrEditUsuarioScreen extends StatefulWidget {
  final Usuario? usuario;

  CreateOrEditUsuarioScreen({this.usuario});

  @override
  _CreateOrEditUsuarioScreenState createState() =>
      _CreateOrEditUsuarioScreenState();
}

class _CreateOrEditUsuarioScreenState extends State<CreateOrEditUsuarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _usuarioController = TextEditingController();
  final _claveController = TextEditingController();
  int _estado = 1; // Por defecto, 1 para activo
  int _rol = 1; // Por defecto, 1 para Administrador General

  @override
  void initState() {
    super.initState();

    if (widget.usuario != null) {
      _nombreController.text = widget.usuario!.nombre;
      _apellidoController.text = widget.usuario!.apellido;
      _emailController.text = widget.usuario!.email;
      _usuarioController.text = widget.usuario!.usuario;
      _claveController.text = widget.usuario!.clave; // Opcional para edición
      _estado = widget.usuario!.estado;
      _rol = widget.usuario!.rol;
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _usuarioController.dispose();
    _claveController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final usuarioData = {
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'usuario': _usuarioController.text,
        'clave': _claveController.text,
        'foto':
            widget.usuario?.foto ?? '', // Mantener foto existente si es edición
        'fecha': widget.usuario == null
            ? DateTime.now().toIso8601String() // Fecha actual al crear
            : widget.usuario!.fecha
                .toIso8601String(), // Mantener la fecha existente al editar
        'ultima_conexion': widget.usuario?.ultimaConexion?.toIso8601String() ??
            DateTime.now().toIso8601String(),
        'estado': _estado,
        'rol': _rol,
      };

      try {
        if (widget.usuario == null) {
          // Crear usuario
          final success = await UsuarioService().createUsuario(usuarioData);
          if (success) {
            Navigator.pop(context);
          } else {
            throw Exception('Failed to create user');
          }
        } else {
          // Editar usuario
          final success = await UsuarioService()
              .updateUsuario(widget.usuario!.id, usuarioData);
          if (success) {
            Navigator.pop(context);
          } else {
            throw Exception('Failed to update user');
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteUsuario() async {
    if (widget.usuario != null) {
      final confirm = await _showConfirmDialog(
        context: context,
        title: 'Eliminar Usuario',
        message: '¿Estás seguro de que deseas eliminar este usuario?',
      );

      if (confirm) {
        try {
          final success =
              await UsuarioService().deleteUsuario(widget.usuario!.id);
          if (success) {
            Navigator.pop(context);
          } else {
            throw Exception('Failed to delete user');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<bool> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.usuario == null ? 'CREAR USUARIO' : 'EDITAR USUARIO',
          style: TextStyle(color: Colors.white), // Color blanco para el título
        ),
        actions: widget.usuario != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await _deleteUsuario();
                  },
                ),
              ]
            : [],
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.usuario == null
                          ? 'Nuevo Usuario'
                          : 'Editar Usuario',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal, // Color para el texto
                              ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _apellidoController,
                      decoration: InputDecoration(
                        labelText: 'Apellido',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el apellido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Por favor ingresa un email válido';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _usuarioController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el nombre de usuario';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _claveController,
                      decoration: InputDecoration(
                        labelText: 'Clave',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la clave';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _estado,
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Activo')),
                        DropdownMenuItem(value: 0, child: Text('Inactivo')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _estado = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _rol,
                      items: [
                        DropdownMenuItem(
                            value: 1, child: Text('Administrador General')),
                        DropdownMenuItem(
                            value: 2,
                            child: Text('Otro Rol')), // Cambia según tus roles
                      ],
                      onChanged: (value) {
                        setState(() {
                          _rol = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Rol',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        foregroundColor:
                            Colors.white, // Color blanco para el texto
                      ),
                      child: Text(
                        widget.usuario == null ? 'Crear' : 'Actualizar',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
