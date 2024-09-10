import 'dart:convert'; // Asegúrate de que esta línea esté presente
import 'package:flutter/material.dart';
import 'dart:io'; // Importa dart:io para usar File
import 'package:appcoffee/models/productor_model.dart';
import 'package:appcoffee/controllers/productor_controller.dart'; // Ajusta la ruta según sea necesario
import 'package:image_picker/image_picker.dart'; // Importa la librería para la selección de imágenes

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
  String _sexo = 'Masculino'; // Valor por defecto
  String _estado = 'Activo'; // Valor por defecto
  final _telefonoController = TextEditingController();
  final _caserioController = TextEditingController();
  final _distritoController = TextEditingController();
  final _provinciaController = TextEditingController();
  final _regionController = TextEditingController();
  final _estatusController = TextEditingController();
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _altitudController = TextEditingController();
  final _fotoController = TextEditingController();

  final ProductorController _controller = ProductorController();

  String? _imagePath; // Variable para almacenar la ruta de la imagen

  @override
  void initState() {
    super.initState();
    if (widget.productor != null) {
      _nombreController.text = widget.productor!.nombre;
      _apellidoController.text = widget.productor!.apellido;
      _dniController.text = widget.productor!.dni.toString();
      _sexo = widget.productor!.sexo;
      _telefonoController.text = widget.productor!.telefono.toString();
      _caserioController.text = widget.productor!.caserio;
      _distritoController.text = widget.productor!.distrito;
      _provinciaController.text = widget.productor!.provincia;
      _regionController.text = widget.productor!.region;
      _estatusController.text = widget.productor!.estatus;
      _latitudController.text = widget.productor!.latitud!;
      _longitudController.text = widget.productor!.longitud!;
      _altitudController.text = widget.productor!.altitud!;
      _fotoController.text =
          widget.productor!.foto ?? ''; // Asignar una cadena vacía si es null
      _estado = widget.productor!.estado == 1
          ? 'Activo'
          : 'Desactivo'; // Ajusta el estado
      _imagePath =
          widget.productor!.foto ?? ''; // Asignar una cadena vacía si es null
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
        source: ImageSource.camera); // O ImageSource.gallery para galería

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);
      final base64Image = await _convertImageToBase64(imageFile);

      if (base64Image != null) {
        setState(() {
          _imagePath = base64Image;
          _fotoController.text =
              _imagePath!; // Asegúrate de que _imagePath no sea null
        });
      }
    }
  }

  Future<String?> _convertImageToBase64(File image) async {
    try {
      final bytes = await image.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      print('Error al convertir la imagen a base64: $e');
      return null;
    }
  }

  Future<void> _saveProductor() async {
    if (_formKey.currentState!.validate()) {
      // Crear el objeto productor con los datos del formulario
      final productor = Productor(
        id: widget.productor?.id ?? '',
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        dni: int.parse(_dniController.text),
        sexo: _sexo,
        telefono: int.parse(_telefonoController.text),
        caserio: _caserioController.text,
        distrito: _distritoController.text,
        provincia: _provinciaController.text,
        region: _regionController.text,
        estatus: _estatusController.text,
        estado: _estado == 'Activo' ? 1 : 0, // Convertir estado a entero
        latitud: _latitudController.text,
        longitud: _longitudController.text,
        altitud: _altitudController.text,
        foto: _imagePath ?? '', // Usar el operador ?? para manejar el caso nulo
        fecha: DateTime.now(),
      );

      try {
        if (widget.productor == null) {
          // Crear un nuevo productor
          await _controller.createProductor(productor);
        } else {
          // Actualizar un productor existente
          await _controller.updateProductor(widget.productor!.id, productor);
        }

        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
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
          await _controller.deleteProductor(widget.productor!.id);
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

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 75, // Ajusta el radio según sea necesario
          backgroundColor: Colors.grey[300],
          backgroundImage: _imagePath != null
              ? MemoryImage(base64Decode(_imagePath!))
              : AssetImage('assets/icons/icon_user.png')
                  as ImageProvider, // Imagen predeterminada
          child: _imagePath == null
              ? Icon(
                  Icons.camera_alt,
                  color: Colors.grey[600],
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildNumberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (int.tryParse(value) == null) {
            return 'Debe ser un número válido';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String value, List<String> options,
      ValueChanged<String?> onChanged, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: options.map((String option) {
          return DropdownMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
        validator: (value) {
          if (value == null) {
            return 'Este campo es obligatorio';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> sexos = ['Masculino', 'Femenino'];
    final List<String> estados = ['Activo', 'Desactivo'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productor == null ? 'Crear Productor' : 'Editar Productor',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: widget.productor != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteProductor,
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
                      widget.productor == null
                          ? 'Nuevo Productor'
                          : 'Editar Productor',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildImagePicker(),
                    SizedBox(height: 16),
                    _buildTextField(_nombreController, 'Nombre'),
                    _buildTextField(_apellidoController, 'Apellido'),
                    _buildNumberField(_dniController, 'DNI'),
                    _buildTextField(_caserioController, 'Caserio'),
                    _buildTextField(_distritoController, 'Distrito'),
                    _buildTextField(_provinciaController, 'Provincia'),
                    _buildTextField(_regionController, 'Región'),
                    _buildTextField(_estatusController, 'Estatus'),
                    _buildNumberField(_telefonoController, 'Teléfono'),
                    _buildNumberField(_latitudController, 'Latitud'),
                    _buildNumberField(_longitudController, 'Longitud'),
                    _buildNumberField(_altitudController, 'Altitud'),
                    SizedBox(height: 16),
                    _buildDropdownField(
                      _sexo,
                      ['Masculino', 'Femenino'],
                      (value) => setState(() => _sexo = value!),
                      'Sexo',
                    ),
                    _buildDropdownField(
                      _estado,
                      ['Activo', 'Desactivo'],
                      (value) => setState(() => _estado = value!),
                      'Estado',
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveProductor,
                      child: Text(
                        widget.productor == null ? 'Crear' : 'Actualizar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors
                            .teal, // Reemplaza primary por backgroundColor
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    )
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
