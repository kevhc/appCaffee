import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateParcelaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Parcela', style: GoogleFonts.lobster()),
      ),
      body: Center(
        child: Text(
          'Aquí puedes crear un nuevo Parcela.',
          style: GoogleFonts.lobster(fontSize: 24),
        ),
      ),
    );
  }
}
