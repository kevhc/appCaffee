import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appcoffee/services/auth_service.dart';

// Widget para campos de texto personalizados con decoración
class CustomTextFieldWithDecoration extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final InputDecoration decoration;

  CustomTextFieldWithDecoration({
    required this.controller,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    required this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: decoration.copyWith(
        prefixIcon: Icon(icon),
        hintText: hintText,
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, ingrese usuario y contraseña')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool success = await AuthService().login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (success) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Credenciales incorrectas')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo animado con gradiente
          AnimatedBackground(),

          // Cuadro de inicio de sesión flotante
          Center(
            child: AnimatedScale(
              scale: _isLoading ? 0.8 : 1.0,
              duration: Duration(milliseconds: 300),
              child: Container(
                padding: EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85), // Más transparente
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.3), // Sombra más marcada
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Bienvenido',
                      style: GoogleFonts.lobster(
                        textStyle: TextStyle(
                          fontSize: 42,
                          color: Colors.teal,
                        ),
                      ),
                    ).animate().fadeIn(duration: 1200.ms).then().scale(),
                    SizedBox(height: 50),
                    CustomTextFieldWithDecoration(
                      controller: _usernameController,
                      icon: Icons.person,
                      hintText: 'Usuario',
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 2.0, // Borde más grueso
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 2.0, // Borde más grueso cuando está enfocado
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 1200.ms).then().scale(),
                    SizedBox(height: 20),
                    CustomTextFieldWithDecoration(
                      controller: _passwordController,
                      icon: Icons.lock,
                      hintText: 'Contraseña',
                      obscureText: true,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 2.0, // Borde más grueso
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Colors.teal,
                            width: 2.0, // Borde más grueso cuando está enfocado
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 1200.ms).then().scale(),
                    SizedBox(height: 40),
                    _isLoading
                        ? CircularProgressIndicator().animate().scale()
                        : ElevatedButton(
                            onPressed: _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Iniciar Sesión'),
                          ).animate().fadeIn(duration: 1200.ms),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.teal.withOpacity(_controller.value),
                Colors.cyanAccent.withOpacity(1 - _controller.value),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
