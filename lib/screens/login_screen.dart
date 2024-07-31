import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appcoffee/widgets/custom_text_field.dart';
import 'package:appcoffee/widgets/custom_button.dart';
import 'package:appcoffee/services/auth_service.dart';

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
      body: Container(
        padding: EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenido',
                style: GoogleFonts.lobster(
                  textStyle: TextStyle(
                    fontSize: 42,
                    color: Colors.white,
                  ),
                ),
              ).animate().fadeIn(duration: 1200.ms).then().scale(),
              SizedBox(height: 50),
              CustomTextField(
                controller: _usernameController,
                icon: Icons.person,
                hintText: 'Usuario',
              ).animate().fadeIn(duration: 1200.ms).then().scale(),
              SizedBox(height: 20),
              CustomTextField(
                controller: _passwordController,
                icon: Icons.lock,
                hintText: 'Contraseña',
                obscureText: true,
              ).animate().fadeIn(duration: 1200.ms).then().scale(),
              SizedBox(height: 40),
              _isLoading
                  ? CircularProgressIndicator().animate().scale()
                  : CustomButton(
                      text: 'Iniciar Sesión',
                      onPressed: _handleLogin,
                    ).animate().fadeIn(duration: 1200.ms),
            ],
          ),
        ),
      ),
    );
  }
}
