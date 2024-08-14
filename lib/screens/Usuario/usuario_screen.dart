import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import '../../services/usuario_service.dart';
import '../../models/usuario_model.dart';
import 'package:appcoffee/screens/Usuario/create_user_screen.dart';
import 'package:appcoffee/widgets/floating_menu.dart';
import 'package:appcoffee/services/usuario_service.dart';
import 'package:appcoffee/services/auth_service.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  late Future<List<Usuario>> _usuarios;

  @override
  void initState() {
    super.initState();
    _usuarios = UsuarioService().fetchUsuarios();
  }

  Future<void> _refreshUsuarios() async {
    setState(() {
      _usuarios = UsuarioService().fetchUsuarios();
    });
  }

  void _showCreateOrEditUsuarioScreen([Usuario? usuario]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrEditUsuarioScreen(usuario: usuario),
      ),
    ).then((_) => _refreshUsuarios());
  }

  Future<void> _logout() async {
    try {
      await AuthService().logout();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'USUARIOS',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateOrEditUsuarioScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _usuarios,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final usuarios = snapshot.data;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: usuarios?.length ?? 0,
            itemBuilder: (context, index) {
              final usuario = usuarios![index];
              Color estadoColor =
                  usuario.estado == 1 ? Colors.green : Colors.red;
              String estadoText = usuario.estado == 1 ? 'Activo' : 'Inactivo';

              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showCreateOrEditUsuarioScreen(usuario);
                      },
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      icon: Icons.edit,
                      label: 'Editar',
                    ),
                  ],
                ),
                endActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        final confirm = await _showConfirmDialog(
                          context: context,
                          title: 'Eliminar Usuario',
                          message:
                              '¿Estás seguro de que deseas eliminar este usuario?',
                        );

                        if (confirm) {
                          try {
                            await UsuarioService().deleteUsuario(usuario.id);
                            _refreshUsuarios();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      },
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: 'Eliminar',
                    ),
                  ],
                ),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      '${usuario.nombre} ${usuario.apellido}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      usuario.email,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: estadoColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        estadoText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () => _showCreateOrEditUsuarioScreen(usuario),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingMenu(
        onHomePressed: () {
          Navigator.pushNamed(context, '/home');
        },
        onProfilePressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        onLogoutPressed: _logout,
      ),
    );
  }

  Future<bool> _showConfirmDialog({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Confirmar'),
          ),
        ],
      ),
    );

    return confirm ?? false;
  }
}
