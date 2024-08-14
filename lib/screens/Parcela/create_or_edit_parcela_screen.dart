import 'package:flutter/material.dart';
import 'package:appcoffee/models/parcela_model.dart';
import 'package:appcoffee/Controllers/parcela_controller.dart';

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
  final ParcelaController _controller = ParcelaController();

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

  Future<void> _saveParcela() async {
    if (_formKey.currentState!.validate()) {
      final parcela = Parcela(
        id: widget.parcela?.id ?? '',
        dni: int.parse(_dniController.text),
        finca: _fincaController.text,
        cafePro: _cafeProController.text,
        cafeCreci: _cafeCreciController.text,
        purma: int.parse(_purmaController.text),
        bosque: int.parse(_bosqueController.text),
        panLlevar: int.parse(_panLlevarController.text),
        pasto: int.parse(_pastoController.text),
        haTotal: int.parse(_haTotalController.text),
        proAnterior: int.parse(_proAnteriorController.text),
        proEstimado: int.parse(_proEstimadoController.text),
        lote: int.parse(_loteController.text),
        ha: int.parse(_haController.text),
        edad: int.parse(_edadController.text),
        proEstimado2: int.parse(_proEstimado2Controller.text),
        caturra: int.parse(_caturraController.text),
        pache: int.parse(_pacheController.text),
        catimor: int.parse(_catimorController.text),
        catuai: int.parse(_catuaiController.text),
        typica: int.parse(_typicaController.text),
        borbon: int.parse(_borbonController.text),
        otro: int.parse(_otroController.text),
        fecha: DateTime.now(),
        estado: _estado,
      );

      try {
        if (widget.parcela == null) {
          await _controller.createParcela(parcela);
        } else {
          await _controller.updateParcela(parcela.id, parcela);
        }

        Navigator.of(context).pop();
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
          await _controller.deleteParcela(widget.parcela!.id);
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
          widget.parcela == null ? 'Crear Parcela' : 'Editar Parcela',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        actions: widget.parcela != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteParcela,
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
                      widget.parcela == null
                          ? 'Nueva Parcela'
                          : 'Editar Parcela',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.teal,
                      ),
                    ),
                    SizedBox(height: 16),
                    _buildTextField(_dniController, 'DNI', 'Número de DNI'),
                    _buildTextField(
                        _fincaController, 'Finca', 'Nombre de la finca'),
                    _buildTextField(_cafeProController, 'Café Producción',
                        'Café de producción'),
                    _buildTextField(_cafeCreciController, 'Café Crecimiento',
                        'Café en crecimiento'),
                    _buildTextField(_purmaController, 'Purma', 'Purma'),
                    _buildTextField(_bosqueController, 'Bosque', 'Bosque'),
                    _buildTextField(
                        _panLlevarController, 'Pan Llevar', 'Pan Llevar'),
                    _buildTextField(_pastoController, 'Pasto', 'Pasto'),
                    _buildTextField(
                        _haTotalController, 'HA Total', 'Hectáreas Totales'),
                    _buildTextField(_proAnteriorController, 'Pro Anterior',
                        'Producción Anterior'),
                    _buildTextField(_proEstimadoController, 'Pro Estimado',
                        'Producción Estimada'),
                    _buildTextField(_loteController, 'Lote', 'Lote'),
                    _buildTextField(_haController, 'HA', 'Hectáreas'),
                    _buildTextField(_edadController, 'Edad', 'Edad'),
                    _buildTextField(_proEstimado2Controller, 'Pro Estimado 2',
                        'Producción Estimada 2'),
                    _buildTextField(_caturraController, 'Caturra', 'Caturra'),
                    _buildTextField(_pacheController, 'Pache', 'Pache'),
                    _buildTextField(_catimorController, 'Catimor', 'Catimor'),
                    _buildTextField(_catuaiController, 'Catuai', 'Catuai'),
                    _buildTextField(_typicaController, 'Typica', 'Typica'),
                    _buildTextField(_borbonController, 'Borbon', 'Borbon'),
                    _buildTextField(_otroController, 'Otro', 'Otro'),
                    SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _estado,
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(),
                      ),
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
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _estado = value;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveParcela,
                      child: Text(
                        widget.parcela == null
                            ? 'Crear Parcela'
                            : 'Actualizar Parcela',
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

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
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
}
