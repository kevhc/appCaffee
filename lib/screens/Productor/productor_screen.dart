import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import 'package:appcoffee/models/productor_model.dart';
import '../../controllers/productor_controller.dart'; // Asegúrate de tener un controlador de Productor
import 'create_or_edit_productor_screen.dart'; // Pantalla para crear o editar productores
import 'package:appcoffee/widgets/floating_menu.dart'; // Ajusta la ruta según sea necesario

class ProductoresScreen extends StatefulWidget {
  @override
  _ProductoresScreenState createState() => _ProductoresScreenState();
}

class _ProductoresScreenState extends State<ProductoresScreen> {
  late Future<List<Productor>> _productores;
  final ProductorController _controller = ProductorController();

  @override
  void initState() {
    super.initState();
    _productores = _controller.fetchProductores();
  }

  Future<void> _refreshProductores() async {
    setState(() {
      _productores = _controller.fetchProductores();
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

  Future<void> _logout() async {
    try {
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión. Inténtalo de nuevo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PRODUCTORES',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
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
            padding: const EdgeInsets.all(16),
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
                            await _controller.deleteProductor(productor.id);
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
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text(
                      '${productor.nombre} ${productor.apellido}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text('DNI: ${productor.dni}'),
                    trailing: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: estadoColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        estadoText,
                        style: TextStyle(
                          color: Colors.white,
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
      floatingActionButton: FloatingMenu(
        onHomePressed: () {
          Navigator.pushNamed(context, '/home');
        },
        onProfilePressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        onLogoutPressed: _logout,
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
