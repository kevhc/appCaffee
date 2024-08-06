import 'package:flutter/material.dart';
import 'package:appcoffee/services/certificado_service.dart';
import 'package:appcoffee/models/certificado_model.dart';

class CreateOrEditCertificadoScreen extends StatefulWidget {
  final Certificado? certificado;

  CreateOrEditCertificadoScreen({this.certificado});

  @override
  _CreateOrEditCertificadoScreenState createState() =>
      _CreateOrEditCertificadoScreenState();
}

class _CreateOrEditCertificadoScreenState
    extends State<CreateOrEditCertificadoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _certificadoController = TextEditingController();
  int _estado = 1; // Por defecto, 1 para activo

  @override
  void initState() {
    super.initState();

    if (widget.certificado != null) {
      _certificadoController.text = widget.certificado!.certificado;
      _estado = widget.certificado!.estado;
    }
  }

  @override
  void dispose() {
    _certificadoController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final certificado = Certificado(
        id: widget.certificado?.id ?? '',
        certificado: _certificadoController.text,
        fecha: widget.certificado == null
            ? DateTime.now() // Fecha actual al crear
            : widget
                .certificado!.fecha, // Mantener la fecha existente al editar
        estado: _estado,
      );

      try {
        if (widget.certificado == null) {
          // Crear certificado sin confirmación
          await CertificadoService().createCertificado(certificado);
        } else {
          // Editar certificado sin confirmación
          await CertificadoService()
              .updateCertificado(certificado.id, certificado);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteCertificado() async {
    if (widget.certificado != null) {
      final confirm = await _showConfirmDialog(
        context: context,
        title: 'Eliminar Certificado',
        message: '¿Estás seguro de que deseas eliminar este certificado?',
      );

      if (confirm) {
        try {
          await CertificadoService().deleteCertificado(widget.certificado!.id);
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
          widget.certificado == null
              ? 'CREAR CERTIFICADO'
              : 'EDITAR CERTIFICADO',
          style: TextStyle(color: Colors.white), // Color blanco para el título
        ),
        actions: widget.certificado != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await _deleteCertificado();
                  },
                ),
              ]
            : [],
        backgroundColor: Colors.teal,
        iconTheme:
            IconThemeData(color: Colors.white), // Color blanco para los íconos
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
                      widget.certificado == null
                          ? 'Nuevo Certificado'
                          : 'Editar Certificado',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal, // Color para el texto
                              ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _certificadoController,
                      decoration: InputDecoration(
                        labelText: 'Certificado',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el certificado';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    if (widget.certificado == null)
                      // Mostrar el campo de fecha solo al crear

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
                        widget.certificado == null ? 'Crear' : 'Actualizar',
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
