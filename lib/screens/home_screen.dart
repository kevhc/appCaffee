import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appcoffee/services/auth_service.dart';
import 'package:appcoffee/screens/create_user_screen.dart';
import 'Productor/productor_screen.dart';
import 'Parcela/parcela_screen.dart';
import 'Certificado/certificado_screen.dart';
import 'Preguntas/pregunta_screen.dart';
import 'package:appcoffee/widgets/loading_screen.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int userRole = 0;
  bool _isMenuOpen = false;
  bool _isHovering = false;
  final AuthService _authService = AuthService();
  String userName = "Cargando...";
  String userProfilePicture =
      "assets/icons/icon_user.png"; // Imagen por defecto

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _loadUserInfo(); // Asegúrate de que esta línea esté incluida para cargar la información del usuario
  }

  Future<void> _loadUserRole() async {
    final role = await _authService.getUserRole();
    setState(() {
      userRole = role ?? 0;
    });
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión. Inténtalo de nuevo.')),
      );
    }
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await _authService.getUserInfo();
    if (userInfo != null) {
      setState(() {
        userName = userInfo['nombre'] ?? "Nombre no disponible";
        userProfilePicture = userInfo['foto'] ?? 'assets/icons/icon_user.png';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aprosem Cafe & Cacao',
          style: GoogleFonts.roboto(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWelcomeBox(),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                  childAspectRatio: 1.5,
                ),
                itemCount: _getMenuItems().length,
                itemBuilder: (context, index) {
                  final item = _getMenuItems()[index];
                  return _buildMenuCard(
                    context,
                    item['title'],
                    item['icon'],
                    item['screen'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildWelcomeBox() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: userProfilePicture.startsWith('http')
                ? NetworkImage(userProfilePicture)
                : AssetImage(userProfilePicture) as ImageProvider,
            radius: 30,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  userName,
                  style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, String title, String imagePath, Widget screen) {
    return GestureDetector(
      onTap: () {
        _navigateToScreen(context, screen);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[200]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getMenuItems() {
    List<Map<String, dynamic>> menuItems = [];

    if (userRole == 1) {
      menuItems.add({
        'title': 'Usuarios',
        'icon': 'assets/icons/icon_user.png',
        'screen': CreateUserScreen(),
      });
    }

    if (userRole == 1 || userRole == 0) {
      menuItems.add({
        'title': 'Productores',
        'icon': 'assets/icons/icon_farmer.png',
        'screen': ProductoresScreen(),
      });

      menuItems.add({
        'title': 'Parcelas',
        'icon': 'assets/icons/icon_plost.png',
        'screen': ParcelasScreen(),
      });
    }

    if (userRole == 1) {
      menuItems.add({
        'title': 'Certificados',
        'icon': 'assets/icons/icon_certificate.png',
        'screen': CertificadosScreen(),
      });

      menuItems.add({
        'title': 'Preguntas',
        'icon': 'assets/icons/icon_question.png',
        'screen': PreguntasScreen(),
      });

      menuItems.add({
        'title': 'Formulario',
        'icon': 'assets/icons/icon_form.png',
        'screen': PreguntasScreen(),
      });
    }

    return menuItems;
  }

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LoadingScreen()),
    );
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => screen),
      );
    });
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    const double buttonSize = 56.0;
    const double arcRadius = 95.0;
    final double angleStep = pi / 4;

    return Stack(
      children: [
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.teal,
            child: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              setState(() {
                _isMenuOpen = !_isMenuOpen;
              });
            },
            shape: CircleBorder(),
          ),
        ),
        if (_isMenuOpen) ...[
          for (int i = 0; i < 3; i++) // 3 buttons: Home, Profile, Logout
            Positioned(
              bottom: 16 + arcRadius * sin(i * angleStep),
              right: 16 + arcRadius * cos(i * angleStep),
              child: GestureDetector(
                onTap: () {
                  if (i == 2) {
                    _logout();
                  }
                },
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  width: _isHovering ? 70.0 : 56.0,
                  height: _isHovering ? 70.0 : 56.0,
                  decoration: BoxDecoration(
                    color: Colors.teal.shade700,
                    shape: BoxShape.circle,
                    boxShadow: [
                      if (_isHovering)
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      i == 0
                          ? Icons.home
                          : i == 1
                              ? Icons.person
                              : Icons.logout,
                      color: Colors.white,
                      size: _isHovering ? 30.0 : 24.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
