import 'package:flutter/material.dart';
import 'views/iam/pantalla_carga.dart'; // Asegúrate de tener este archivo
import 'package:google_fonts/google_fonts.dart';


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


/*
import 'package:flutter/material.dart';
import 'views/historial_notas_view.dart';
import 'views/medicacion_form_view.dart';
import 'views/calendar_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalendarView(), // Nueva vista
    );
  }
}
*/
