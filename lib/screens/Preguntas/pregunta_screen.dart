import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import '../../services/pregunta_service.dart';
import '../../models/pregunta_model.dart';
import 'create_or_edit_pregunta.dart';

class PreguntasScreen extends StatefulWidget {
  @override
  _PreguntasScreenState createState() => _PreguntasScreenState();
}

class _PreguntasScreenState extends State<PreguntasScreen> {
  late Future<List<Pregunta>> _preguntas;

  @override
  void initState() {
    super.initState();
    _preguntas = PreguntaService().fetchPreguntas();
  }

  Future<void> _refreshPreguntas() async {
    setState(() {
      _preguntas = PreguntaService().fetchPreguntas();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preguntas'),
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        titleTextStyle: TextStyle(
          color: Colors.white, // Color del texto del título
          fontSize: 20, // Tamaño de la fuente del título
          fontWeight: FontWeight.bold, // Peso de la fuente
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateOrEditPreguntaScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors
              .white, // Color de los íconos del AppBar, incluida la flecha de retroceso
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
                            await PreguntaService().deletePregunta(pregunta.id);
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
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  elevation: 5,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      pregunta.pregunta,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: estadoColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        estadoText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
