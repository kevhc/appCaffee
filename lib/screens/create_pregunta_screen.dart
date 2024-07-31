import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreatePreguntaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Pregunta', style: GoogleFonts.lobster()),
      ),
      body: Center(
        child: Text(
          'Aquí puedes crear un nuevo Pregunta.',
          style: GoogleFonts.lobster(fontSize: 24),
        ),
      ),
    );
  }
}
