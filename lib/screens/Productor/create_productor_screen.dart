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
  final _caserioController = TextEditingController();
  final _distritoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _regionController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _longitudController = TextEditingController();
  final _latitudController = TextEditingController();
  final _altitudController = TextEditingController();

  String? _selectedSexo;
  String? _selectedEstatus;
  int _estado = 1; // Por defecto, 1 para activo
  File? _image;

  @override
  void initState() {
    super.initState();

    if (widget.productor != null) {
      final productor = widget.productor!;
      _nombreController.text = productor.nombre;
      _apellidoController.text = productor.apellido;
      _dniController.text = productor.dni.toString();
      _caserioController.text = productor.caserio;
      _distritoController.text = productor.distrito;
      _provinciaController.text = productor.provincia;
      _regionController.text = productor.region;
      _telefonoController.text = productor.telefono.toString();
      _longitudController.text = productor.longitud;
      _latitudController.text = productor.latitud;
      _altitudController.text = productor.altitud;
      _estado = productor.estado;
      _selectedSexo = productor.sexo;
      _selectedEstatus = productor.estatus;
      if (productor.foto.isNotEmpty) {
        _image = File(productor.foto);
      }
    } else {
      _selectedSexo = 'Masculino'; // Valor por defecto
      _selectedEstatus = 'C0'; // Valor por defecto
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoController.dispose();
    _dniController.dispose();
    _caserioController.dispose();
    _distritoController.dispose();
    _provinciaController.dispose();
    _regionController.dispose();
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
        dni: int.tryParse(_dniController.text) ?? 0,
        sexo: _selectedSexo!,
        caserio: _caserioController.text,
        distrito: _distritoController.text,
        provincia: _provinciaController.text,
        region: _regionController.text,
        estatus: _selectedEstatus!,
        telefono: int.tryParse(_telefonoController.text) ?? 0,
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
      try {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
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
          widget.productor == null ? 'CREAR PRODUCTOR' : 'EDITAR PRODUCTOR',
          style: TextStyle(color: Colors.white),
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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: _image == null
                        ? Icon(Icons.camera_alt, size: 50)
                        : null,
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nombreController,
                  decoration: InputDecoration(labelText: 'Nombre'),
                  validator: (value) =>
                      value!.isEmpty ? 'El nombre es requerido' : null,
                ),
                TextFormField(
                  controller: _apellidoController,
                  decoration: InputDecoration(labelText: 'Apellido'),
                  validator: (value) =>
                      value!.isEmpty ? 'El apellido es requerido' : null,
                ),
                TextFormField(
                  controller: _dniController,
                  decoration: InputDecoration(labelText: 'DNI'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El DNI es requerido';
                    } else if (int.tryParse(value) == null) {
                      return 'El DNI debe ser un número';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedSexo,
                  items: ['Masculino', 'Femenino']
                      .map((sexo) => DropdownMenuItem(
                            value: sexo,
                            child: Text(sexo),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSexo = value;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Sexo'),
                  validator: (value) =>
                      value == null ? 'El sexo es requerido' : null,
                ),
                TextFormField(
                  controller: _caserioController,
                  decoration: InputDecoration(labelText: 'Caserio'),
                ),
                TextFormField(
                  controller: _distritoController,
                  decoration: InputDecoration(labelText: 'Distrito'),
                ),
                TextFormField(
                  controller: _provinciaController,
                  decoration: InputDecoration(labelText: 'Provincia'),
                ),
                TextFormField(
                  controller: _regionController,
                  decoration: InputDecoration(labelText: 'Región'),
                ),
                TextFormField(
                  controller: _telefonoController,
                  decoration: InputDecoration(labelText: 'Teléfono'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'El teléfono es requerido';
                    } else if (int.tryParse(value) == null) {
                      return 'El teléfono debe ser un número';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _longitudController,
                  decoration: InputDecoration(labelText: 'Longitud'),
                ),
                TextFormField(
                  controller: _latitudController,
                  decoration: InputDecoration(labelText: 'Latitud'),
                ),
                TextFormField(
                  controller: _altitudController,
                  decoration: InputDecoration(labelText: 'Altitud'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(widget.productor == null
                      ? 'Crear Productor'
                      : 'Actualizar Productor'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
