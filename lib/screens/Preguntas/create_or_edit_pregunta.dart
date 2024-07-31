import 'package:flutter/material.dart';
import 'package:appcoffee/services/pregunta_service.dart'; // Cambiado a servicio de Pregunta
import 'package:appcoffee/models/pregunta_model.dart'; // Cambiado a modelo de Pregunta

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

  @override
  void initState() {
    super.initState();

    if (widget.pregunta != null) {
      _preguntaController.text = widget.pregunta!.pregunta;
      _estado = widget.pregunta!.estado;
    }
  }

  @override
  void dispose() {
    _preguntaController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final pregunta = Pregunta(
        id: widget.pregunta?.id ?? '',
        pregunta: _preguntaController.text,
        fecha: widget.pregunta == null
            ? DateTime.now() // Fecha actual al crear
            : widget.pregunta!.fecha, // Mantener la fecha existente al editar
        estado: _estado,
      );

      if (widget.pregunta == null) {
        // Crear pregunta
        try {
          await PreguntaService().createPregunta(pregunta);
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } else {
        // Editar pregunta
        try {
          await PreguntaService().updatePregunta(pregunta.id, pregunta);
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
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
          await PreguntaService().deletePregunta(widget.pregunta!.id);
          Navigator.pop(context);
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
            style:
                TextStyle(color: Colors.white)), // Color blanco para el título
        actions: widget.pregunta != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await _deletePregunta();
                  },
                ),
              ]
            : [],
        backgroundColor: Colors.teal,
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
                      widget.pregunta == null
                          ? 'Nueva Pregunta'
                          : 'Editar Pregunta',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal, // Color para el texto
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
                          return 'Por favor ingresa la pregunta';
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
                        widget.pregunta == null ? 'Crear' : 'Actualizar',
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
