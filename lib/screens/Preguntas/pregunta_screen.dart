import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import '../../models/preguntas_model.dart'; // Asegúrate de tener un modelo de Pregunta
import '../../Controllers/pregunta_controller.dart'; // Asegúrate de tener un controlador de Pregunta
import 'create_or_edit_pregunta_screen.dart'; // Pantalla para crear o editar preguntas
import 'package:appcoffee/services/auth_service.dart';
import 'package:appcoffee/widgets/floating_menu.dart';

class PreguntasScreen extends StatefulWidget {
  @override
  _PreguntasScreenState createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  late Future<List<Pregunta>> _preguntas;
  final PreguntaController _controller = PreguntaController();

  @override
  void initState() {
    super.initState();
    _preguntas = _controller.fetchPreguntas();
  }

  Future<void> _refreshPreguntas() async {
    setState(() {
      _preguntas = _controller.fetchPreguntas();
    });
  }

  void _showCreateOrEditPreguntaScreen([Pregunta? pregunta]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrEditPreguntaScreen(pregunta: pregunta),
      ),
    ).then((_) => _refreshPreguntas());
  }

  Future<void> _logout() async {
    try {
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
          'PREGUNTAS',
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
            onPressed: () => _showCreateOrEditPreguntaScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Pregunta>>(
        future: _preguntas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final preguntas = snapshot.data;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: preguntas?.length ?? 0,
            itemBuilder: (context, index) {
              final pregunta = preguntas![index];
              Color estadoColor =
                  pregunta.estado == 1 ? Colors.green : Colors.red;
              String estadoText = pregunta.estado == 1 ? 'Activo' : 'Inactivo';

              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showCreateOrEditPreguntaScreen(pregunta);
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
                          title: 'Eliminar Pregunta',
                          message:
                              '¿Estás seguro de que deseas eliminar esta pregunta?',
                        );

                        if (confirm) {
                          try {
                            await _controller.deletePregunta(pregunta.id);
                            _refreshPreguntas();
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
                      pregunta.pregunta, // Aquí ajusta el campo de pregunta
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
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
                        ),
                      ),
                    ),
                    onTap: () => _showCreateOrEditPreguntaScreen(pregunta),
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
