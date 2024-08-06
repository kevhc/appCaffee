import 'package:flutter/material.dart';
import 'package:appcoffee/services/parcela_service.dart';
import 'package:appcoffee/models/parcela_model.dart';

class CreateOrEditParcelaScreen extends StatefulWidget {
  final Parcela? parcela;

  CreateOrEditParcelaScreen({this.parcela});

  @override
  _CreateOrEditParcelaScreenState createState() =>
      _CreateOrEditParcelaScreenState();
}

class _CreateOrEditParcelaScreenState extends State<CreateOrEditParcelaScreen> {
  final _formKey = GlobalKey<FormState>();

  final _dniController = TextEditingController();
  final _fincaController = TextEditingController();
  final _cafeProController = TextEditingController();
  final _cafeCreciController = TextEditingController();
  final _purmaController = TextEditingController();
  final _bosqueController = TextEditingController();
  final _panLlevarController = TextEditingController();
  final _pastoController = TextEditingController();
  final _haTotalController = TextEditingController();
  final _proAnteriorController = TextEditingController();
  final _proEstimadoController = TextEditingController();
  final _loteController = TextEditingController();
  final _haController = TextEditingController();
  final _edadController = TextEditingController();
  final _proEstimado2Controller = TextEditingController();
  final _caturraController = TextEditingController();
  final _pacheController = TextEditingController();
  final _catimorController = TextEditingController();
  final _catuaiController = TextEditingController();
  final _typicaController = TextEditingController();
  final _borbonController = TextEditingController();
  final _otroController = TextEditingController();

  int _estado = 1; // Por defecto, 1 para activo

  @override
  void initState() {
    super.initState();

    if (widget.parcela != null) {
      _dniController.text = widget.parcela!.dni.toString();
      _fincaController.text = widget.parcela!.finca;
      _cafeProController.text = widget.parcela!.cafePro;
      _cafeCreciController.text = widget.parcela!.cafeCreci;
      _purmaController.text = widget.parcela!.purma.toString();
      _bosqueController.text = widget.parcela!.bosque.toString();
      _panLlevarController.text = widget.parcela!.panLlevar.toString();
      _pastoController.text = widget.parcela!.pasto.toString();
      _haTotalController.text = widget.parcela!.haTotal.toString();
      _proAnteriorController.text = widget.parcela!.proAnterior.toString();
      _proEstimadoController.text = widget.parcela!.proEstimado.toString();
      _loteController.text = widget.parcela!.lote.toString();
      _haController.text = widget.parcela!.ha.toString();
      _edadController.text = widget.parcela!.edad.toString();
      _proEstimado2Controller.text = widget.parcela!.proEstimado2.toString();
      _caturraController.text = widget.parcela!.caturra.toString();
      _pacheController.text = widget.parcela!.pache.toString();
      _catimorController.text = widget.parcela!.catimor.toString();
      _catuaiController.text = widget.parcela!.catuai.toString();
      _typicaController.text = widget.parcela!.typica.toString();
      _borbonController.text = widget.parcela!.borbon.toString();
      _otroController.text = widget.parcela!.otro.toString();
      _estado = widget.parcela!.estado;
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    _fincaController.dispose();
    _cafeProController.dispose();
    _cafeCreciController.dispose();
    _purmaController.dispose();
    _bosqueController.dispose();
    _panLlevarController.dispose();
    _pastoController.dispose();
    _haTotalController.dispose();
    _proAnteriorController.dispose();
    _proEstimadoController.dispose();
    _loteController.dispose();
    _haController.dispose();
    _edadController.dispose();
    _proEstimado2Controller.dispose();
    _caturraController.dispose();
    _pacheController.dispose();
    _catimorController.dispose();
    _catuaiController.dispose();
    _typicaController.dispose();
    _borbonController.dispose();
    _otroController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final parcela = Parcela(
        id: widget.parcela?.id ?? '',
        dni: int.tryParse(_dniController.text) ?? 0,
        finca: _fincaController.text,
        cafePro: _cafeProController.text,
        cafeCreci: _cafeCreciController.text,
        purma: int.tryParse(_purmaController.text) ?? 0,
        bosque: int.tryParse(_bosqueController.text) ?? 0,
        panLlevar: int.tryParse(_panLlevarController.text) ?? 0,
        pasto: int.tryParse(_pastoController.text) ?? 0,
        haTotal: int.tryParse(_haTotalController.text) ?? 0,
        proAnterior: int.tryParse(_proAnteriorController.text) ?? 0,
        proEstimado: int.tryParse(_proEstimadoController.text) ?? 0,
        lote: int.tryParse(_loteController.text) ?? 0,
        ha: int.tryParse(_haController.text) ?? 0,
        edad: int.tryParse(_edadController.text) ?? 0,
        proEstimado2: int.tryParse(_proEstimado2Controller.text) ?? 0,
        caturra: int.tryParse(_caturraController.text) ?? 0,
        pache: int.tryParse(_pacheController.text) ?? 0,
        catimor: int.tryParse(_catimorController.text) ?? 0,
        catuai: int.tryParse(_catuaiController.text) ?? 0,
        typica: int.tryParse(_typicaController.text) ?? 0,
        borbon: int.tryParse(_borbonController.text) ?? 0,
        otro: int.tryParse(_otroController.text) ?? 0,
        fecha: widget.parcela == null ? DateTime.now() : widget.parcela!.fecha,
        estado: _estado,
      );

      try {
        if (widget.parcela == null) {
          // Crear parcela
          await ParcelaService().createParcela(parcela);
        } else {
          // Editar parcela
          await ParcelaService().updateParcela(parcela.id, parcela);
        }
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _deleteParcela() async {
    if (widget.parcela != null) {
      final confirm = await _showConfirmDialog(
        context: context,
        title: 'Eliminar Parcela',
        message: '¿Estás seguro de que deseas eliminar esta parcela?',
      );

      if (confirm) {
        try {
          await ParcelaService().deleteParcela(widget.parcela!.id);
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
          widget.parcela == null ? 'CREAR PARCELA' : 'Editar PARCELA',
          style: TextStyle(color: Colors.white), // Color blanco para el título
        ),
        actions: widget.parcela != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white),
                  onPressed: () async {
                    await _deleteParcela();
                  },
                ),
              ]
            : [],
        backgroundColor: Colors.teal,
        iconTheme: IconThemeData(color: Colors.white), // Co
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
                      widget.parcela == null
                          ? 'Nueva Parcela'
                          : 'Editar Parcela',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Color negro para el título
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextFormField(
                      controller: _dniController,
                      labelText: 'DNI',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: _fincaController,
                      labelText: 'Finca',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: _cafeProController,
                      labelText: 'Café Producción',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    _buildTextFormField(
                      controller: _cafeCreciController,
                      labelText: 'Café Crecimiento',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        return null;
                      },
                    ),
                    _buildNumberFormField(
                      controller: _purmaController,
                      labelText: 'Purma',
                    ),
                    _buildNumberFormField(
                      controller: _bosqueController,
                      labelText: 'Bosque',
                    ),
                    _buildNumberFormField(
                      controller: _panLlevarController,
                      labelText: 'Pan Llevar',
                    ),
                    _buildNumberFormField(
                      controller: _pastoController,
                      labelText: 'Pasto',
                    ),
                    _buildNumberFormField(
                      controller: _haTotalController,
                      labelText: 'Ha Total',
                    ),
                    _buildNumberFormField(
                      controller: _proAnteriorController,
                      labelText: 'Pro Anterior',
                    ),
                    _buildNumberFormField(
                      controller: _proEstimadoController,
                      labelText: 'Pro Estimado',
                    ),
                    _buildNumberFormField(
                      controller: _loteController,
                      labelText: 'Lote',
                    ),
                    _buildNumberFormField(
                      controller: _haController,
                      labelText: 'Ha',
                    ),
                    _buildNumberFormField(
                      controller: _edadController,
                      labelText: 'Edad',
                    ),
                    _buildNumberFormField(
                      controller: _proEstimado2Controller,
                      labelText: 'Pro Estimado 2',
                    ),
                    _buildNumberFormField(
                      controller: _caturraController,
                      labelText: 'Caturra',
                    ),
                    _buildNumberFormField(
                      controller: _pacheController,
                      labelText: 'Pache',
                    ),
                    _buildNumberFormField(
                      controller: _catimorController,
                      labelText: 'Catimor',
                    ),
                    _buildNumberFormField(
                      controller: _catuaiController,
                      labelText: 'Catuai',
                    ),
                    _buildNumberFormField(
                      controller: _typicaController,
                      labelText: 'Typica',
                    ),
                    _buildNumberFormField(
                      controller: _borbonController,
                      labelText: 'Borbon',
                    ),
                    _buildNumberFormField(
                      controller: _otroController,
                      labelText: 'Otro',
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Estado',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<int>(
                          value: _estado,
                          onChanged: (int? newValue) {
                            setState(() {
                              _estado = newValue!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: 1,
                              child: Text('Activo'),
                            ),
                            DropdownMenuItem(
                              value: 0,
                              child: Text('Inactivo'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                        widget.parcela == null
                            ? 'CREAR PARCELA'
                            : 'ACTUALIZAR PARCELA',
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

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildNumberFormField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Este campo es obligatorio';
          }
          if (int.tryParse(value) == null) {
            return 'Ingrese un número válido';
          }
          return null;
        },
      ),
    );
  }
}
