import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import '../../services/parcela_service.dart';
import '../../models/parcela_model.dart';
import 'create_or_edit_parcela_screen.dart';

class ParcelasScreen extends StatefulWidget {
  @override
  _ParcelasScreenState createState() => _ParcelasScreenState();
}

class _ParcelasScreenState extends State<ParcelasScreen> {
  late Future<List<Parcela>> _parcelas;

  @override
  void initState() {
    super.initState();
    _parcelas = ParcelaService().fetchParcelas();
  }

  Future<void> _refreshParcelas() async {
    setState(() {
      _parcelas = ParcelaService().fetchParcelas();
    });
  }

  void _showCreateOrEditParcelaScreen([Parcela? parcela]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrEditParcelaScreen(parcela: parcela),
      ),
    ).then((_) => _refreshParcelas());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parcelas'),
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        titleTextStyle: TextStyle(
          color: Colors.white, // Color del texto del título
          fontSize: 20, // Tamaño de la fuente del título
          fontWeight: FontWeight.bold, // Peso de la fuente
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateOrEditParcelaScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors
              .white, // Color de los íconos del AppBar, incluida la flecha de retroceso
        ),
      ),
      body: FutureBuilder<List<Parcela>>(
        future: _parcelas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final parcelas = snapshot.data;

          return ListView.builder(
            itemCount: parcelas?.length ?? 0,
            itemBuilder: (context, index) {
              final parcela = parcelas![index];
              Color estadoColor =
                  parcela.estado == 1 ? Colors.green : Colors.red;
              String estadoText = parcela.estado == 1 ? 'Activo' : 'Inactivo';

              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showCreateOrEditParcelaScreen(parcela);
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
                          title: 'Eliminar Parcela',
                          message:
                              '¿Estás seguro de que deseas eliminar esta parcela?',
                        );

                        if (confirm) {
                          try {
                            await ParcelaService().deleteParcela(parcela.id);
                            _refreshParcelas();
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
                      parcela.finca,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Alinea el texto a la izquierda
                      children: [
                        Text(
                          'DNI: ${parcela.dni}',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Hectarea Total: ${parcela.haTotal}',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
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
                    onTap: () => _showCreateOrEditParcelaScreen(parcela),
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
