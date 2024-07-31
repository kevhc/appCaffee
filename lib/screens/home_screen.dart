import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:appcoffee/services/auth_service.dart';
import 'package:appcoffee/screens/create_user_screen.dart';
import 'package:appcoffee/screens/create_productor_screen.dart';
import 'package:appcoffee/screens/create_parcelas_screen.dart';
import 'Certificado/certificado_screen.dart';
import 'package:appcoffee/screens/create_pregunta_screen.dart';
import 'package:appcoffee/widgets/loading_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userRole = 0; // Valor por defecto en caso de error

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final role = await AuthService().getUserRole();
    setState(() {
      userRole = role ?? 0; // Valor por defecto si no se puede obtener el rol
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graficos', style: GoogleFonts.lobster()),
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Aquí puedes poner la URL de la foto del usuario
            ).animate().fadeIn(duration: 1200.ms).then().scale(),
            SizedBox(height: 20),
            Text('Bienvenido, Usuario',
                style: GoogleFonts.lobster(fontSize: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          // Contenedor del menú lateral
          Container(
            color: Colors.white, // Fondo blanco para todo el menú lateral
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SizedBox(
                          height:
                              40), // Margen superior para dar espacio al ícono
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      'https://via.placeholder.com/150'), // Aquí puedes poner la URL de la foto del usuario
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Nombre del Usuario', // Aquí puedes colocar el nombre del usuario
                                    style: GoogleFonts.lobster(fontSize: 18),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                      if (userRole == 1) // Solo para usuarios con rol general
                        _buildListTile(context, 'Usuarios', Icons.people, [
                          _buildSubMenu(
                              context, 'Crear', Icons.add, CreateUserScreen()),
                          // _buildSubMenu(context, 'Editar', Icons.edit,
                          //     EditUserScreen()), // Implementa EditUserScreen
                          // _buildSubMenu(context, 'Lista', Icons.list,
                          //     ListUserScreen()), // Implementa ListUserScreen
                        ]),
                      if (userRole == 1 || userRole == 0) // Para ambos roles
                        _buildListTile(context, 'Productores', Icons.people, [
                          _buildSubMenu(context, 'Crear', Icons.add,
                              CreateProductorScreen()),
                          //   _buildSubMenu(context, 'Editar', Icons.edit,
                          //       EditProductorScreen()), // Implementa EditProductorScreen
                          //   _buildSubMenu(context, 'Lista', Icons.list,
                          //       ListProductorScreen()), // Implementa ListProductorScreen
                        ]),
                      if (userRole == 1 || userRole == 0) // Para ambos roles
                        _buildListTile(context, 'Parcelas', Icons.landscape, [
                          _buildSubMenu(context, 'Crear', Icons.add,
                              CreateParcelaScreen()),
                          //   _buildSubMenu(context, 'Editar', Icons.edit,
                          //       EditParcelaScreen()), // Implementa EditParcelaScreen
                          //   _buildSubMenu(context, 'Lista', Icons.list,
                          //       ListParcelaScreen()), // Implementa ListParcelaScreen
                        ]),
                      if (userRole == 1) // Solo para usuarios con rol general
                        _buildListTile(
                            context, 'Certificados', Icons.verified, [
                          _buildSubMenu(context, 'Lista', Icons.add,
                              CertificadosScreen()),
                          //   _buildSubMenu(context, 'Editar', Icons.edit,
                          //       EditCertificadoScreen()), // Implementa EditCertificadoScreen
                          //   _buildSubMenu(context, 'Lista', Icons.list,
                          //       ListCertificadoScreen()), // Implementa ListCertificadoScreen
                        ]),
                      if (userRole == 1) // Solo para usuarios con rol general
                        _buildListTile(
                            context, 'Preguntas', Icons.question_answer, [
                          _buildSubMenu(context, 'Crear', Icons.add,
                              CreatePreguntaScreen()), // Implementa CreatePreguntaScreen
                          //   _buildSubMenu(context, 'Editar', Icons.edit,
                          //       EditPreguntaScreen()), // Implementa EditPreguntaScreen
                          //   _buildSubMenu(context, 'Lista', Icons.list,
                          //       ListPreguntaScreen()), // Implementa ListPreguntaScreen
                        ]),
                      if (userRole == 1) // Solo para usuarios con rol general
                        // _buildListTile(
                        //     context, 'Formulario', Icons.question_answer, [
                        //   _buildSubMenu(context, 'Crear', Icons.add,
                        //       CreateFormularioScreen()), // Implementa CreateFormularioScreen
                        //   //   _buildSubMenu(context, 'Editar', Icons.edit,
                        //   //       EditFormularioScreen()), // Implementa EditFormularioScreen
                        //   //   _buildSubMenu(context, 'Lista', Icons.list,
                        //   //       ListFormularioScreen()), // Implementa ListFormularioScreen
                        // ]),
                        SizedBox(
                            height: 10), // Espacio antes de "Cerrar Sesión"
                      ListTile(
                        leading: Icon(Icons.logout,
                            size: 20), // Tamaño del ícono de cerrar sesión
                        title: Text(
                          'Cerrar Sesión',
                          style: TextStyle(fontSize: 14), // Tamaño de la fuente
                        ),
                        onTap: () async {
                          await AuthService().logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                      ).animate().fadeIn(duration: 250.ms).then().scale(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Icono de cerrar
          Positioned(
            top: 16,
            right: 12, // Ajustado para la esquina superior derecha
            child: IconButton(
              icon: Icon(Icons.close, size: 25),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el menú lateral
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, String title, IconData icon, List<Widget> subMenu) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent, // Elimina el color de resaltado
        highlightColor: Colors.transparent, // Elimina el color de resaltado
      ),
      child: ExpansionTile(
        leading: Icon(icon, size: 20), // Tamaño del ícono
        title: Text(
          title,
          style: TextStyle(fontSize: 16), // Tamaño de la fuente
        ),
        tilePadding:
            EdgeInsets.symmetric(horizontal: 16.0), // Ajusta el padding
        children: subMenu,
        backgroundColor: Colors.white, // Fondo blanco de la expansión
        collapsedBackgroundColor:
            Colors.white, // Fondo blanco del tile colapsado
        expandedCrossAxisAlignment: CrossAxisAlignment.start, // Sin contornos
        expandedAlignment: Alignment.centerLeft,
      ).animate().fadeIn(duration: 250.ms).then().scale(),
    );
  }

  Widget _buildSubMenu(
      BuildContext context, String title, IconData icon, Widget screen) {
    return Container(
      color: Colors.white, // Fondo blanco para los sub-menús
      child: ListTile(
        leading: Icon(icon, size: 20), // Tamaño del ícono
        title: Text(
          title,
          style: TextStyle(fontSize: 14), // Tamaño de la fuente
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => LoadingScreen(),
            ),
          );
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => screen),
            );
          });
        },
      ).animate().fadeIn(duration: 250.ms).then().scale(),
    );
  }
}
