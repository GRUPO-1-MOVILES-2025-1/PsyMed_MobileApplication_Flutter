import 'dart:async';
import 'package:flutter/material.dart';
import 'login_view.dart';

class PantallaCargaView extends StatefulWidget {
  const PantallaCargaView({super.key});

  @override
  State<PantallaCargaView> createState() => _PantallaCargaViewState();
}

class _PantallaCargaViewState extends State<PantallaCargaView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1800),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginView()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFF10BEAE),
      body: SafeArea(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 🔧 centra horizontalmente
            children: [
              Spacer(flex: 3),
              Center( // 🔧 asegura que la imagen también esté centrada
                child: Image.asset(
                  'assets/images/logo_psymed.png',
                  height: size.height * 0.2,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "PsyMed",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              Spacer(flex: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Text(
                  "Bienestar mental a tu alcance",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
