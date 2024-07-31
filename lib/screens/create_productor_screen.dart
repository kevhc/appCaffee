import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateProductorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Productor', style: GoogleFonts.lobster()),
      ),
      body: Center(
        child: Text(
          'Aquí puedes crear un nuevo productor.',
          style: GoogleFonts.lobster(fontSize: 24),
        ),
      ),
    );
  }
}
