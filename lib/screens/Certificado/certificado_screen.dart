import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart'; // Paquete para deslizar
import '../../services/certificado_service.dart';
import '../../models/certificado_model.dart';
import 'create_or_edit_certificado_screen.dart';

class CertificadosScreen extends StatefulWidget {
  @override
  _CertificadosScreenState createState() => _CertificadosScreenState();
}

class _CertificadosScreenState extends State<CertificadosScreen> {
  late Future<List<Certificado>> _certificados;

  @override
  void initState() {
    super.initState();
    _certificados = CertificadoService().fetchCertificados();
  }

  Future<void> _refreshCertificados() async {
    setState(() {
      _certificados = CertificadoService().fetchCertificados();
    });
  }

  void _showCreateOrEditCertificadoScreen([Certificado? certificado]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateOrEditCertificadoScreen(certificado: certificado),
      ),
    ).then((_) => _refreshCertificados());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Certificados'),
        backgroundColor: Colors.teal, // Color de fondo del AppBar
        titleTextStyle: TextStyle(
          color: Colors.white, // Color del texto del título
          fontSize: 20, // Tamaño de la fuente del título
          fontWeight: FontWeight.bold, // Peso de la fuente
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => _showCreateOrEditCertificadoScreen(),
          ),
        ],
        iconTheme: IconThemeData(
          color: Colors
              .white, // Color de los íconos del AppBar, incluida la flecha de retroceso
        ),
      ),
      body: FutureBuilder<List<Certificado>>(
        future: _certificados,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final certificados = snapshot.data;

          return ListView.builder(
            itemCount: certificados?.length ?? 0,
            itemBuilder: (context, index) {
              final certificado = certificados![index];
              Color estadoColor =
                  certificado.estado == 1 ? Colors.green : Colors.red;
              String estadoText =
                  certificado.estado == 1 ? 'Activo' : 'Inactivo';

              return Slidable(
                startActionPane: ActionPane(
                  motion: const DrawerMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) {
                        _showCreateOrEditCertificadoScreen(certificado);
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
                          title: 'Eliminar Certificado',
                          message:
                              '¿Estás seguro de que deseas eliminar este certificado?',
                        );

                        if (confirm) {
                          try {
                            await CertificadoService()
                                .deleteCertificado(certificado.id);
                            _refreshCertificados();
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
                      certificado.certificado,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                    onTap: () =>
                        _showCreateOrEditCertificadoScreen(certificado),
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
