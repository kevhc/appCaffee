import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../services/productor_service.dart';
import '../../models/productor_model.dart';
import 'create_productor_screen.dart';

class ProductoresScreen extends StatefulWidget {
  @override
  _ProductoresScreenState createState() => _ProductoresScreenState();
}

class _ProductoresScreenState extends State<ProductoresScreen> {
  late Future<List<Productor>> _productores;

  @override
  void initState() {
    super.initState();
    _productores = ProductorService().fetchProductores();
  }

  Future<void> _refreshProductores() async {
    setState(() {
      _productores = ProductorService().fetchProductores();
    });
  }

  void _showCreateOrEditProductorScreen([Productor? productor]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateOrEditProductorScreen(productor: productor),
      ),
    ).then((_) => _refreshProductores());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productores'),
        backgroundColor: Colors.teal,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateOrEditProductorScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: FutureBuilder<List<Productor>>(
        future: _productores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final productores = snapshot.data;

          return ListView.builder(
            itemCount: productores?.length ?? 0,
            itemBuilder: (context, index) {
              final productor = productores![index];
              Color estadoColor =
                  productor.estado == 1 ? Colors.green : Colors.red;
              String estadoText = productor.estado == 1 ? 'Activo' : 'Inactivo';

              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showCreateOrEditProductorScreen(productor);
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
                          title: 'Eliminar Productor',
                          message:
                              '¿Estás seguro de que deseas eliminar este productor?',
                        );

                        if (confirm) {
                          try {
                            await ProductorService()
                                .deleteProductor(productor.id);
                            _refreshProductores();
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
                      '${productor.nombre} ${productor.apellido}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                        'DNI: ${productor.dni}\nTeléfono: ${productor.telefono}'),
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
                    onTap: () => _showCreateOrEditProductorScreen(productor),
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
