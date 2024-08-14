import 'package:flutter/material.dart';
import 'package:appcoffee/models/certificado_model.dart';
import '../../Controllers/certificado_controller.dart';

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
  final CertificadoController _controller = CertificadoController();

  @override
  void initState() {
    super.initState();
    if (widget.certificado != null) {
      _certificadoController.text = widget.certificado!.certificado;
      _estado = widget.certificado!.estado;
    }
  }

  Future<void> _saveCertificado() async {
    if (_formKey.currentState!.validate()) {
      final certificado = Certificado(
        id: widget.certificado?.id ?? '',
        certificado: _certificadoController.text,
        fecha: DateTime.now(),
        estado: _estado,
      );

      try {
        if (widget.certificado == null) {
          await _controller.createCertificado(certificado);
        } else {
          await _controller.updateCertificado(certificado.id, certificado);
        }

        Navigator.of(context).pop();
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
          await _controller.deleteCertificado(widget.certificado!.id);
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
          widget.certificado == null
              ? 'Crear Certificado'
              : 'Editar Certificado',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20, // Tamaño del texto
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: widget.certificado != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteCertificado,
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
                      widget.certificado == null
                          ? 'Nuevo Certificado'
                          : 'Editar Certificado',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.teal,
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
                      onPressed: _saveCertificado,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Fondo del botón
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Borde redondeado
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16), // Padding
                      ),
                      child: Text(
                        widget.certificado == null ? 'Crear' : 'Actualizar',
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
