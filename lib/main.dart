import 'package:flutter/material.dart';
import 'package:appcoffee/screens/login_screen.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:appcoffee/screens/home_screen.dart'; // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define las rutas para la navegación
      initialRoute: '/login', // Pantalla inicial
      routes: {
        '/login': (context) => LoginScreen(),
        '/home': (context) =>
            HomeScreen(), // Define HomeScreen si aún no lo has hecho
      },
    );
  }
}
