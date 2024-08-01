import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:appcoffee/models/productor_model.dart';
import 'package:appcoffee/services/productor_service.dart';

class CreateOrEditProductorScreen extends StatefulWidget {
  final Productor? productor;

  CreateOrEditProductorScreen({this.productor});

  @override
  _CreateOrEditProductorScreenState createState() =>
      _CreateOrEditProductorScreenState();
}

class _CreateOrEditProductorScreenState
    extends State<CreateOrEditProductorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _dniController = TextEditingController();
  final _sexoController = TextEditingController();
  final _caserioController = TextEditingController();
  final _distritoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _regionController = TextEditingController();
  final _estatusController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _longitudController = TextEditingController();
  final _latitudController = TextEditingController();
  final _altitudController = TextEditingController();

  int _estado = 1; // Por defecto, 1 para activo
  File? _image;

  @override
  void initState() {
    super.initState();

    if (widget.productor != null) {
      _nombreController.text = widget.productor!.nombre;
      _apellidoController.text = widget.productor!.apellido;
      _dniController.text = widget.productor!.dni.toString();
      _sexoController.text = widget.productor!.sexo;
      _caserioController.text = widget.productor!.caserio;
      _distritoController.text = widget.productor!.distrito;
      _provinciaController.text = widget.productor!.provincia;
      _regionController.text = widget.productor!.region;
      _estatusController.text = widget.productor!.estatus;
      _telefonoController.text = widget.productor!.telefono.toString();
      _longitudController.text = widget.productor!.longitud;
      _latitudController.text = widget.productor!.latitud;
      _altitudController.text = widget.productor!.altitud;
      _estado = widget.productor!.estado;
      if (widget.productor!.foto.isNotEmpty) {
        _image = File(widget.productor!.foto);
      }
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _sexoController.dispose();
    _caserioController.dispose();
    _distritoController.dispose();
    _provinciaController.dispose();
    _regionController.dispose();
    _estatusController.dispose();
    _telefonoController.dispose();
    _longitudController.dispose();
    _latitudController.dispose();
    _altitudController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final productor = Productor(
        id: widget.productor?.id ?? '',
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        dni: int.parse(_dniController.text),
        sexo: _sexoController.text,
        caserio: _caserioController.text,
        distrito: _distritoController.text,
        provincia: _provinciaController.text,
        region: _regionController.text,
        estatus: _estatusController.text,
        telefono: int.parse(_telefonoController.text),
        longitud: _longitudController.text,
        latitud: _latitudController.text,
        altitud: _altitudController.text,
        foto: _image?.path ?? '',
        fecha: widget.productor?.fecha ?? DateTime.now(),
        estado: _estado,
      );

      try {
        if (widget.productor == null) {
          // Crear productor
          await ProductorService().createProductor(productor, _image);
        } else {
          // Editar productor
          await ProductorService().updateProductor(
            productor.id,
            productor,
            _image,
          );
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    final source = await _showImageSourceDialog();
    if (source != null) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    }
  }

  Future<ImageSource?> _showImageSourceDialog() async {
    return showDialog<ImageSource?>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Seleccionar Imagen'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(ImageSource.camera);
            },
            child: Text('Tomar Foto'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(ImageSource.gallery);
            },
            child: Text('Seleccionar de la Galería'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProductor() async {
    if (widget.productor != null) {
      final confirm = await _showConfirmDialog(
        context: context,
        title: 'Eliminar Productor',
        message: '¿Estás seguro de que deseas eliminar este productor?',
      );

      if (confirm) {
        try {
          await ProductorService().deleteProductor(widget.productor!.id);
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
          widget.productor == null ? 'Crear Productor' : 'Editar Productor',
          style: TextStyle(color: Colors.white), // Color blanco para el título
        ),
        actions: widget.productor != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await _deleteProductor();
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
                      widget.productor == null
                          ? 'Nuevo Productor'
                          : 'Editar Productor',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                      controller: _dniController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'DNI',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el DNI';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _sexoController,
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el sexo';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _caserioController,
                      decoration: InputDecoration(
                        labelText: 'Caserio',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el caserio';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _distritoController,
                      decoration: InputDecoration(
                        labelText: 'Distrito',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el distrito';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _provinciaController,
                      decoration: InputDecoration(
                        labelText: 'Provincia',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la provincia';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _regionController,
                      decoration: InputDecoration(
                        labelText: 'Región',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la región';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _estatusController,
                      decoration: InputDecoration(
                        labelText: 'Estatus',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el estatus';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _telefonoController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Teléfono',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa el teléfono';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _longitudController,
                      decoration: InputDecoration(
                        labelText: 'Longitud',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la longitud';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _latitudController,
                      decoration: InputDecoration(
                        labelText: 'Latitud',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la latitud';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _altitudController,
                      decoration: InputDecoration(
                        labelText: 'Altitud',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingresa la altitud';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _image != null
                        ? Image.file(
                            _image!,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Placeholder(
                            fallbackHeight: 200,
                          ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('Seleccionar Imagen'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Color del botón
                        foregroundColor:
                            Colors.white, // Color del texto del botón
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(widget.productor == null
                          ? 'Crear Productor'
                          : 'Actualizar Productor'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // Color del botón
                        foregroundColor:
                            Colors.white, // Color del texto del botón
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
