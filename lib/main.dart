import 'package:flutter/material.dart';
import 'views/pantalla_carga.dart'; // Asegúrate de tener este archivo


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PsyMed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PantallaCargaView(),
    );
  }
}
