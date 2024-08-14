import 'package:flutter/material.dart';
import 'package:appcoffee/models/preguntas_model.dart';
import 'package:appcoffee/Controllers/pregunta_controller.dart';

class CreateOrEditPreguntaScreen extends StatefulWidget {
  final Pregunta? pregunta;

  CreateOrEditPreguntaScreen({this.pregunta});

  @override
  _CreateOrEditPreguntaScreenState createState() =>
      _CreateOrEditPreguntaScreenState();
}

class _CreateOrEditPreguntaScreenState
    extends State<CreateOrEditPreguntaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _preguntaController = TextEditingController();
  int _estado = 1; // Por defecto, 1 para activo
  final PreguntaController _controller = PreguntaController();

  @override
  void initState() {
    super.initState();
    if (widget.pregunta != null) {
      _preguntaController.text = widget.pregunta!.pregunta;
      _estado = widget.pregunta!.estado;
    }
  }

  Future<void> _savePregunta() async {
    if (_formKey.currentState!.validate()) {
      final pregunta = Pregunta(
        id: widget.pregunta?.id ?? '',
        pregunta: _preguntaController.text,
        fecha: DateTime.now(),
        estado: _estado,
      );

      try {
        if (widget.pregunta == null) {
          await _controller.createPregunta(pregunta);
        } else {
          await _controller.updatePregunta(pregunta.id, pregunta);
        }

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deletePregunta() async {
    if (widget.pregunta != null) {
      final confirm = await _showConfirmDialog(
        context: context,
        title: 'Eliminar Pregunta',
        message: '¿Estás seguro de que deseas eliminar esta pregunta?',
      );

      if (confirm) {
        try {
          await _controller.deletePregunta(widget.pregunta!.id);
          Navigator.of(context).pop();
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
          widget.pregunta == null ? 'Crear Pregunta' : 'Editar Pregunta',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Tamaño del texto
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: widget.pregunta != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deletePregunta,
                ),
              ]
            : [],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.pregunta == null
                          ? 'Nueva Pregunta'
                          : 'Editar Pregunta',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _preguntaController,
                      decoration: InputDecoration(
                        labelText: 'Pregunta',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _estado,
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      items: [
                        DropdownMenuItem(value: 1, child: Text('Activo')),
                        DropdownMenuItem(value: 0, child: Text('Inactivo')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _estado = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _savePregunta,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Borde redondeado
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16), // Padding
                      ),
                      child: Text(
                        widget.pregunta == null ? 'Crear' : 'Actualizar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
